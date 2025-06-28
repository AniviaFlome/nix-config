#!/usr/bin/env bash
# workaround for picture in picture like chrome

Link="$1"
Launch_Options=""
Launch_Options+=" --really-quiet --fs=no --force-window"
Launch_Options+=" --volume=60"
Launch_Options+=" --autofit=30% --geometry=-10-15"
# i3 -> for_window [class="mpv" instance="Picture-in-Picture"] floating enable
Launch_Options+=" --x11-name=Picture-in-Picture"

Launch_cmd=(${pkgs.mpv} $Launch_Options "$Link")
"${Launch_cmd[@]}" &

# i3-specifics
if [[ $XDG_SESSION_DESKTOP == "i3" ]] || [[ "$DESKTOP_SESSION" == "i3" ]]; then
	mpv_pid="$!"
	while [[ ! $(xdotool search --pid $mpv_pid) ]]; do sleep 0.1; done
	mpv_WID=$(xdotool search --pid $mpv_pid)
	i3-msg "[id=${mpv_WID}] floating enable"
	i3-msg "[id=${mpv_WID}] sticky enable" # Make it 'On-Top'
fi
