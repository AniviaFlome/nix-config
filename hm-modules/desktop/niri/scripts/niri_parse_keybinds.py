#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# ---------------------------------------------------------------------------------------------------------------------
# %% Handle script args

from os.path import expanduser
import argparse

# For clarity
default_kdl = "~/.config/niri/config.kdl"
default_sep_kb = "\t| "
default_sep_title = " |\t"
default_line_end = "\n"

parser = argparse.ArgumentParser(
    description="Parse niri keybinds into 'dmenu' friendly format",
    epilog="The results from this script can be piped to a launcher for display, eg. using: '| fuzzel -d'",
)
parser.add_argument(
    "-i", "--keybind_kdl", type=str, default=default_kdl, help=f"Path to keybinds.kdl (default: {default_kdl})"
)
parser.add_argument(
    "-t",
    "--exclude_titles",
    action="store_true",
    help="If set, the 'hotkey-overlay-title' text will not be included in the output",
)
parser.add_argument(
    "-s",
    "--include_spawn_prefix",
    action="store_true",
    help="If set, 'spawn' and 'spawn-sh' will be included in the output",
)
parser.add_argument(
    "-c",
    "--include_command_quotes",
    action="store_true",
    help="If set, aprostrophes & quotation marks will not be removed from commands",
)
parser.add_argument("-pk", "--pad_keybind", type=int, default=8, help="Padding added to keybinds (default: 8)")
parser.add_argument("-pt", "--pad_title", type=int, default=32, help="Padding added to titles (default: 32)")
parser.add_argument(
    "-ak",
    "--sep_keybind",
    type=str,
    default=default_sep_kb,
    help=f"Separator after keybind text (default: {default_sep_kb!r})",
)
parser.add_argument(
    "-at",
    "--sep_title",
    type=str,
    default=default_sep_title,
    help=f"Separator after title text (default: {default_sep_title!r})",
)
parser.add_argument(
    "-e",
    "--output_line_end",
    type=str,
    default=default_line_end,
    help=f"Line ending (terminating) string when generating output (default: {default_line_end!r})",
)

# For convenience
args = parser.parse_args()
KEYBIND_KDL_PATH = expanduser(args.keybind_kdl)
INCLUDE_OVERLAY_TITLES = not args.exclude_titles
REMOVE_CMD_QUOTATIONS = not args.include_command_quotes
REMOVE_SPAWN_PREFIX = not args.include_spawn_prefix
PAD_KEYBIND = args.pad_keybind
PAD_TITLE = args.pad_title
SEP_KEYBIND = args.sep_keybind
SEP_TITLE = args.sep_title
OUTPUT_LINE_END = args.output_line_end


# ---------------------------------------------------------------------------------------------------------------------
# %% Parse kdl file

# Read all keybind data
try:
    with open(KEYBIND_KDL_PATH, "r") as infile:
        full_text = infile.read()
except FileNotFoundError:
    import subprocess

    notify_title, notify_explain = "Error parsing keybinds!", f"Not found: {KEYBIND_KDL_PATH}"
    subprocess.run(["notify-send", notify_title, notify_explain])
    raise FileNotFoundError(KEYBIND_KDL_PATH)

# Try to get the text after the 'binds {...}' section
# -> We can't just search for 'binds' or 'binds {', because the text 'binds'
#    may appear elsewhere (e.g. in comments) in the file, and 'binds    {'
#    (i.e. with extra spaces before the curly bracket) is considered valid
if full_text.startswith("binds"):
    # Assume we're dealing with a stand-alone keybinds.kdl file that starts with 'binds {'
    first_line_break_idx = full_text.index("\n")
    text_after_binds = full_text[1 + first_line_break_idx :]
else:
    # Assume the 'binds {' line is further into the file, so we catch it after a newline
    before_and_after_binds = full_text.split("\nbinds")
    if len(before_and_after_binds) != 2:
        import subprocess

        notify_title, notify_explain = "Error parsing keybinds!", "Could not find binds {...} section"
        subprocess.run(["notify-send", notify_title, notify_explain])
        raise IOError(f"Error parsing keybinds: {KEYBIND_KDL_PATH}")

    # Assume we have: ["...text before 'binds {', "rest of text, including binds"]
    text_after_binds = before_and_after_binds[1]

# Grab every line from the binds section, not including comments/blanks lines
filtered_list = []
for full_line in text_after_binds.splitlines():

    # Get rid of indents
    line = full_line.strip()

    # Stop when we hit the end of the binds {...} section (assumed to be marked by a single '}')
    if line == "}":
        break

    # Skip comments and other junk lines
    if line.startswith("//") or len(line) < 3:
        continue

    # Try to separate config/command (e.g. 'Mod+K ...' vs. '{ spawn ... ; }' parts)
    # -> Expecting result like: ["config before command", "command ;}"],
    config_command_split = line.split("{")
    if len(config_command_split) != 2:
        if len(config_command_split) > 2:
            print("Error parsing keybind! Unexpected double curly bracket:", line, sep="\n", flush=True)
        continue

    # Break apart binding config & command parts
    config, command = config_command_split
    config_split = config.split(" ", 1)
    command_split = command.split(";")

    # Get the first command (e.g. 'Mod+Q') & command
    keybind_str = config_split[0].ljust(PAD_KEYBIND)
    command_str = command_split[0].strip()

    # Remove 'spawn' or 'spawn-sh' if needed
    if REMOVE_SPAWN_PREFIX and command_str.startswith("spawn"):
        command_str = command_str.removeprefix("spawn-sh " if "spawn-sh" in command_str else "spawn ")
    if REMOVE_CMD_QUOTATIONS:
        command_str = command_str.replace('"', "").replace("'", "")

    # Grab hotkey title if needed
    title_str = ""
    if INCLUDE_OVERLAY_TITLES:
        target_str = "hotkey-overlay-title="
        if target_str in config:
            _, title_split = config.split(target_str)
            if not title_split.startswith("null"):
                str_marker = title_split[0]
                _, title_str, _ = title_split.split(str_marker)

    # Join the keybind + title + command into 1 line for printing
    final_strs = (
        (keybind_str, SEP_KEYBIND, title_str.ljust(PAD_TITLE), SEP_TITLE, command_str)
        if len(title_str) > 0
        else (keybind_str, SEP_KEYBIND, command_str)
    )
    filtered_line = "".join(final_strs)
    filtered_list.append(filtered_line)

# Print results to console (for piping into other programs)
print(OUTPUT_LINE_END.join(filtered_list))
