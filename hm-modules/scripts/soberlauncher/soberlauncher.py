#!/usr/bin/env python3

import sys
import os
import subprocess
import shutil
import json
import re

from PyQt6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QFileDialog,
    QLineEdit, QMessageBox, QInputDialog, QLabel, QDialog, QSizePolicy, QListWidget,
    QAbstractItemView, QCheckBox, QDialogButtonBox, QTabWidget, QMenu
)
from PyQt6.QtGui import QIcon, QPixmap, QPalette, QColor, QBrush
from PyQt6.QtCore import QThread, pyqtSignal, QTimer, Qt

__version__ = "Release V1.5"


class UpdateThread(QThread):
    update_failed = pyqtSignal(str)
    update_success = pyqtSignal()

    def run(self):
        try:
            subprocess.run(
                ["python3", os.path.join(os.path.dirname(__file__), "update.py")],
                check=True
            )
            self.update_success.emit()
        except subprocess.CalledProcessError as e:
            self.update_failed.emit(str(e))

    def __init__(self):
        super().__init__()


class CreateProfileDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Create Profile")
        layout = QVBoxLayout(self)

        self.name_input = QLineEdit(self)
        self.name_input.setPlaceholderText("Enter the profile name")
        layout.addWidget(QLabel("Profile Name:"))
        layout.addWidget(self.name_input)

        self.copy_checkbox = QCheckBox(
            "Copy the main profile's folder (will make Roblox immediately available without having to redownload it after)",
            self
        )
        layout.addWidget(self.copy_checkbox)

        self.buttons = QDialogButtonBox(
            QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel,
            self
        )
        self.buttons.accepted.connect(self.accept)
        self.buttons.rejected.connect(self.reject)
        layout.addWidget(self.buttons)

    def getData(self):
        return self.name_input.text().strip(), self.copy_checkbox.isChecked()


class SoberLauncher(QWidget):
    def __init__(self):
        super().__init__()
        # État
        self.base_dir = None
        self.profiles = []
        self.selected_profiles = []
        self.processes = {}            # profile_name -> subprocess.Popen
        self.launched_profiles = set() # profils lancés durant cette session
        self.settings_json = "SL_Settings.json"
        self.legacy_settings_txt = "SL_Settings.txt"
        self.legacy_last_dir_txt = "last_directory.txt"

        # Réglages
        self.display_name = "[Name]"
        self.privateServers = []  # liste de tuples (name, parameter)
        self.roblox_player_enabled = False  # toggle Roblox Player tab (default off)
        self.allow_multi_instance = False   # default OFF

        # Internal UI refs
        self.instances_layout = None
        self.bottom_layout_added = False

        # Charger réglages (JSON + migration auto)
        self.loadSettings()

        # UI
        self.initUI()

        # Charger profils si base_dir connu
        self.scanForProfiles()

        # Timer pour checker les processus
        self.process_timer = QTimer(self)
        self.process_timer.timeout.connect(self.checkProcesses)
        self.process_timer.start(2000)

    # ------------- Réglages (JSON + migration) -------------

    def loadSettings(self):
        data = {}

        # 1) Si JSON existe, on charge
        if os.path.exists(self.settings_json):
            try:
                with open(self.settings_json, "r", encoding="utf-8") as f:
                    data = json.load(f)
            except Exception:
                data = {}

        # 2) Sinon, on tente migration depuis SL_Settings.txt + last_directory.txt
        else:
            base_dir = None
            name = "[Name]"
            servers = []

            # Lire last_directory.txt (hérité)
            if os.path.exists(self.legacy_last_dir_txt):
                try:
                    with open(self.legacy_last_dir_txt, "r", encoding="utf-8") as f:
                        base_dir = os.path.abspath(f.read().strip()) or None
                except Exception:
                    base_dir = None

            # Lire SL_Settings.txt (hérité)
            if os.path.exists(self.legacy_settings_txt):
                try:
                    with open(self.legacy_settings_txt, "r", encoding="utf-8") as f:
                        lines = [line.strip() for line in f.readlines()]
                    for line in lines:
                        if line.startswith("last_directory="):
                            v = line[len("last_directory="):].strip()
                            base_dir = os.path.abspath(v) if v else base_dir
                        elif line.startswith("Name="):
                            name = line[len("Name="):] or "[Name]"
                        elif line.startswith("PrivateServers="):
                            raw = line[len("PrivateServers="):]
                            if raw:
                                for s in raw.split(","):
                                    if "|" in s:
                                        n, p = s.split("|", 1)
                                        servers.append({"name": n, "parameter": p})
                except Exception:
                    pass

            data = {
                "last_directory": base_dir,
                "Name": name,
                "PrivateServers": servers,
                "roblox_player_enabled": False,
                "AllowMultiInstance": False,
            }

            try:
                with open(self.settings_json, "w", encoding="utf-8") as f:
                    json.dump(data, f, ensure_ascii=False, indent=2)
            except Exception:
                pass

        # Appliquer
        self.base_dir = data.get("last_directory") or None
        self.display_name = data.get("Name", self.display_name)

        normalized = []
        for item in data.get("PrivateServers", []):
            if isinstance(item, dict) and "name" in item and "parameter" in item:
                normalized.append((item["name"], item["parameter"]))
            elif isinstance(item, (list, tuple)) and len(item) == 2:
                normalized.append((item[0], item[1]))
        self.privateServers = normalized

        self.roblox_player_enabled = bool(data.get("roblox_player_enabled", False))
        self.allow_multi_instance = bool(data.get("AllowMultiInstance", False))

    def saveSettings(self):
        data = {
            "last_directory": self.base_dir,
            "Name": self.display_name,
            "PrivateServers": [{"name": n, "parameter": p} for (n, p) in self.privateServers],
            "roblox_player_enabled": self.roblox_player_enabled,
            "AllowMultiInstance": self.allow_multi_instance,
        }
        try:
            with open(self.settings_json, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to save settings: {e}")

    # ------------- Profils / Processus -------------

    def createProfile(self):
        if not self.base_dir:
            QMessageBox.warning(self, "Error", "Please select a base directory first.")
            return

        dialog = CreateProfileDialog(self)
        if dialog.exec() == QDialog.DialogCode.Accepted:
            profile_name, copy_main = dialog.getData()
            if not profile_name:
                QMessageBox.warning(self, "Error", "Enter a valid profile name.")
                return

            profile_path = os.path.join(self.base_dir, profile_name)
            local_path = os.path.join(profile_path, ".local")

            try:
                os.makedirs(profile_path, exist_ok=True)
                os.makedirs(local_path, exist_ok=True)
                if copy_main:
                    import getpass
                    user = getpass.getuser()
                    src = f"/home/{user}/.var/app/org.vinegarhq.Sober/"
                    dst_parent = os.path.join(profile_path, ".var/app/")
                    os.makedirs(dst_parent, exist_ok=True)
                    subprocess.run(["cp", "-r", src, dst_parent], check=True)
                    appdata_path = os.path.join(dst_parent, "org.vinegarhq.Sober/data/sober/appData")
                    if os.path.exists(appdata_path):
                        subprocess.run(["rm", "-rf", appdata_path], check=True)
                self.scanForProfiles()
                QMessageBox.information(self, "Profile Created", f"Profile '{profile_name}' created successfully!")
            except Exception as e:
                QMessageBox.warning(self, "Error", f"Failed to create profile directory: {e}")

    def system_sober_running(self) -> bool:
        """
        Return True if any org.vinegarhq.Sober instance is running on the system,
        even if it was not launched from this app.
        """
        # Try flatpak ps first
        try:
            res = subprocess.run(["flatpak", "ps"], capture_output=True, text=True)
            if res.returncode == 0 and "org.vinegarhq.Sober" in res.stdout:
                return True
        except Exception:
            pass

        # Fallback to pgrep on the command line
        try:
            res = subprocess.run(["pgrep", "-af", "flatpak run org.vinegarhq.Sober"], capture_output=True, text=True)
            if res.returncode == 0 and res.stdout.strip():
                return True
        except Exception:
            pass

        # Last resort: grep the process list
        try:
            res = subprocess.run(["ps", "-eo", "pid,cmd"], capture_output=True, text=True)
            if res.returncode == 0 and "org.vinegarhq.Sober" in res.stdout:
                return True
        except Exception:
            pass

        return False

    def _guard_multi_instance(self, requested_count: int = 1):
        """
        Guard against launching multiple instances when disabled.
        requested_count: how many instances the user is attempting to launch.
        """
        if not self.allow_multi_instance:
            if requested_count > 1:
                QMessageBox.warning(self, "Error", "A Profile is already running, try closing it before opening a new one")
                return False
            if self.system_sober_running():
                QMessageBox.warning(self, "Error", "A Profile is already running, try closing it before opening a new one")
                return False
        return True

    def launchGame(self):
        if not self.selected_profiles:
            QMessageBox.warning(self, "Error", "No profiles selected.")
            return

        # When multi-instance is disabled, block multi-selection entirely
        requested = len(self.selected_profiles) if self.allow_multi_instance else 1
        if not self._guard_multi_instance(requested_count=requested):
            return

        targets = self.selected_profiles if self.allow_multi_instance else [self.selected_profiles[0]]

        for profile in targets:
            if profile in self.processes and self.processes[profile].poll() is None:
                continue  # already running from this launcher

            if profile == "Main Profile":
                proc = subprocess.Popen("flatpak run org.vinegarhq.Sober", shell=True)
            else:
                profile_path = os.path.join(self.base_dir, profile)
                command = f'env HOME="{profile_path}" flatpak run org.vinegarhq.Sober'
                proc = subprocess.Popen(command, shell=True)
            self.processes[profile] = proc
            self.launched_profiles.add(profile)
        self.updateMissingInstancesLabel()

    def checkProcesses(self):
        closed = [p for p, proc in self.processes.items() if proc.poll() is not None]
        for p in closed:
            del self.processes[p]
        self.updateMissingInstancesLabel()

    def runWithConsole(self):
        if not self.selected_profiles:
            QMessageBox.warning(self, "Error", "No profiles selected.")
            return

        requested = len(self.selected_profiles) if self.allow_multi_instance else 1
        if not self._guard_multi_instance(requested_count=requested):
            return

        terminal_command = None
        if shutil.which("konsole"):
            terminal_command = "konsole -e"
        elif shutil.which("x-terminal-emulator"):
            terminal_command = "x-terminal-emulator -e"
        elif shutil.which("gnome-terminal"):
            terminal_command = "gnome-terminal --"
        else:
            QMessageBox.critical(self, "Error", "No compatible terminal emulator found.")
            return

        targets = self.selected_profiles if self.allow_multi_instance else [self.selected_profiles[0]]

        for profile in targets:
            if profile in self.processes and self.processes[profile].poll() is None:
                continue

            if profile == "Main Profile":
                proc = subprocess.Popen(f"{terminal_command} flatpak run org.vinegarhq.Sober", shell=True)
            else:
                profile_path = os.path.join(self.base_dir, profile)
                command = f'{terminal_command} env HOME="{profile_path}" flatpak run org.vinegarhq.Sober'
                proc = subprocess.Popen(command, shell=True)
            self.processes[profile] = proc
            self.launched_profiles.add(profile)
        self.updateMissingInstancesLabel()

    def runSpecificGame(self):
        if not self.selected_profiles:
            QMessageBox.warning(self, "Error", "No profiles selected.")
            return

        requested = len(self.selected_profiles) if self.allow_multi_instance else 1
        if not self._guard_multi_instance(requested_count=requested):
            return

        url, ok = QInputDialog.getText(self, "Game Link", "Enter the game link:")
        if ok and url.strip():
            match = re.search(r"games/(\d+)", url.strip())
            if not match:
                QMessageBox.warning(self, "Error", "Invalid Roblox game link.")
                return

            place_id = match.group(1)
            roblox_command = f'roblox://experience?placeId={place_id}'

            targets = self.selected_profiles if self.allow_multi_instance else [self.selected_profiles[0]]

            for profile in targets:
                if profile in self.processes and self.processes[profile].poll() is None:
                    continue

                if profile == "Main Profile":
                    proc = subprocess.Popen(f'flatpak run org.vinegarhq.Sober "{roblox_command}"', shell=True)
                else:
                    profile_path = os.path.join(self.base_dir, profile)
                    command = f'env HOME="{profile_path}" flatpak run org.vinegarhq.Sober "{roblox_command}"'
                    proc = subprocess.Popen(command, shell=True)
                self.processes[profile] = proc
                self.launched_profiles.add(profile)
            self.updateMissingInstancesLabel()

    def scanForProfiles(self):
        self.profileList.clear()
        profiles = []

        if self.base_dir and os.path.exists(self.base_dir):
            with os.scandir(self.base_dir) as entries:
                for entry in entries:
                    if entry.is_dir():
                        local_path = os.path.join(entry.path, ".local")
                        if os.path.exists(local_path) and os.path.isdir(local_path):
                            profiles.append(entry.name)

        def natural_sort_key(s):
            return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

        profiles.sort(key=natural_sort_key)
        if "Main Profile" in profiles:
            profiles.remove("Main Profile")
        profiles.insert(0, "Main Profile")

        self.profileList.addItems(profiles)
        self.updateMissingInstancesLabel(profiles)

    def updateMissingInstancesLabel(self, profiles=None):
        # If multi-instancing disabled, do nothing (UI hidden)
        if not self.allow_multi_instance:
            return

        if not hasattr(self, "missingInstancesLabel"):
            return

        running = list(self.processes.keys())
        missing = [p for p in self.launched_profiles if p not in running]
        if missing:
            text = "Launched instances not running: " + ", ".join(missing)
        else:
            text = "Launched instances not running: None"

        font = self.missingInstancesLabel.font()
        base_size = 12
        max_len = 60
        if len(text) > max_len:
            font.setPointSize(max(base_size - (len(text) - max_len) // 8, 7))
        else:
            font.setPointSize(base_size)
        self.missingInstancesLabel.setFont(font)
        self.missingInstancesLabel.setText(text)

        # Highlight missing profiles in blue in the list
        self.colorizeMissingProfiles(missing)

    def colorizeMissingProfiles(self, missing):
        # Determine default text color from current palette (to restore non-missing)
        default_color = self.palette().color(QPalette.ColorRole.WindowText)
        for i in range(self.profileList.count()):
            item = self.profileList.item(i)
            if self.allow_multi_instance and item.text() in missing:
                item.setForeground(QBrush(QColor("#1e3a8a")))  # dark blue
            else:
                item.setForeground(QBrush(default_color))

    def runMissingInstances(self):
        if not self.allow_multi_instance:
            QMessageBox.information(self, "Info", "Multi instancing is disabled.")
            return

        running = list(self.processes.keys())
        missing = [p for p in self.launched_profiles if p not in running]
        if not missing:
            QMessageBox.information(self, "Info", "No missing instances to run.")
            return
        for profile in missing:
            if profile == "Main Profile":
                proc = subprocess.Popen("flatpak run org.vinegarhq.Sober", shell=True)
            else:
                profile_path = os.path.join(self.base_dir, profile)
                command = f'env HOME="{profile_path}" flatpak run org.vinegarhq.Sober'
                proc = subprocess.Popen(command, shell=True)
            self.processes[profile] = proc
            self.launched_profiles.add(profile)
        self.updateMissingInstancesLabel()

    def exitAllSessions(self):
        result = QMessageBox.question(
            self, "Confirm Exit",
            "Do you want to force-close all Sober sessions?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        )
        if result == QMessageBox.StandardButton.Yes:
            subprocess.run("flatpak kill org.vinegarhq.Sober", shell=True)
            self.launched_profiles.clear()
            self.updateMissingInstancesLabel()
            QMessageBox.information(self, "Exit", "All Sober sessions have been forcibly closed.")

    # ------------- À propos / Update -------------

    def showAbout(self):
        dialog = QDialog(self)
        dialog.setWindowTitle("About Sober Launcher")
        layout = QVBoxLayout()

        icon_label = QLabel()
        icon_label.setPixmap(QPixmap(os.path.join(os.path.dirname(os.path.abspath(__file__)), "SoberLauncher.svg")))
        title_label = QLabel("<b>Sober Launcher</b><br>An easy launcher to control all your Sober Instances<br><br><i>Author: Taboulet</i>")
        version_label = QLabel(f"<b>Current Version:</b> {__version__}")

        layout.addWidget(icon_label)
        layout.addWidget(title_label)
        layout.addWidget(version_label)

        # Toggle for Roblox Player stuff
        toggle_row = QHBoxLayout()
        toggle_label = QLabel("Activate Roblox Player stuff")
        self.robloxToggle = QCheckBox()
        self.robloxToggle.setChecked(self.roblox_player_enabled)
        self.robloxToggle.stateChanged.connect(self.onRobloxToggleChanged)
        toggle_row.addWidget(toggle_label)
        toggle_row.addWidget(self.robloxToggle)
        toggle_row.addStretch(1)
        layout.addLayout(toggle_row)

        # Toggle for Multi Instancing (broken)
        multi_row = QHBoxLayout()
        multi_label = QLabel("Enable Multi Instancing (broken)")
        self.multiToggle = QCheckBox()
        self.multiToggle.setChecked(self.allow_multi_instance)
        self.multiToggle.stateChanged.connect(self.onMultiToggleChanged)
        multi_row.addWidget(multi_label)
        multi_row.addWidget(self.multiToggle)
        multi_row.addStretch(1)
        layout.addLayout(multi_row)

        update_button = QPushButton("Update")
        update_button.clicked.connect(self.runUpdateScript)
        layout.addWidget(update_button)

        dialog.setLayout(layout)
        dialog.exec()

    def onRobloxToggleChanged(self, state):
        self.roblox_player_enabled = (state == Qt.CheckState.Checked.value)
        self.saveSettings()
        self.updateRobloxTabVisibility()

    def onMultiToggleChanged(self, state):
        self.allow_multi_instance = (state == Qt.CheckState.Checked.value)
        self.saveSettings()
        # Update UI to reflect mode immediately and restore/hide bottom layout correctly
        self.applyMultiInstanceUIState()

    def updateRobloxTabVisibility(self):
        # Add or remove the Roblox Player tab depending on the toggle
        idx = self.main_tab_widget.indexOf(self.roblox_tab)
        if self.roblox_player_enabled:
            if idx == -1:
                self.main_tab_widget.addTab(self.roblox_tab, "Roblox Player")
        else:
            if idx != -1:
                self.main_tab_widget.removeTab(idx)

        # Hide the tab bar when only one tab is visible (no wasted space)
        show_tabs = self.main_tab_widget.count() > 1
        self.main_tab_widget.tabBar().setVisible(show_tabs)

        # Keep focus on the remaining tab
        if self.main_tab_widget.count() >= 1 and self.main_tab_widget.currentIndex() == -1:
            self.main_tab_widget.setCurrentIndex(0)

    def runUpdateScript(self):
        self.update_thread = UpdateThread()
        self.update_thread.update_failed.connect(lambda error: QMessageBox.critical(self, "Error", f"Failed to run update script: {error}"))
        self.update_thread.update_success.connect(lambda: QMessageBox.information(self, "Update", "Update completed successfully."))
        self.update_thread.start()

    # ------------- Crash windows -------------

    def removeCrashWindows(self):
        try:
            result = subprocess.run(
                ["xdotool", "search", "--name", "Crash"], capture_output=True, text=True
            )
            if result.returncode != 0 or not result.stdout.strip():
                QMessageBox.information(self, "Info", "No 'Crash' windows found.")
                return

            window_ids = result.stdout.strip().split("\n")
            for window_id in window_ids:
                subprocess.run(["xdotool", "windowkill", window_id])
        except FileNotFoundError:
            QMessageBox.critical(
                self, "Error", "The 'xdotool' command is not available. Please ensure it is installed."
            )

    # ------------- Lancement via lien pour manquants -------------

    def runMissingInstancesWithLink(self):
        if not self.allow_multi_instance:
            QMessageBox.information(self, "Info", "Multi instancing is disabled.")
            return

        running = list(self.processes.keys())
        missing = [p for p in self.launched_profiles if p not in running]
        if not missing:
            QMessageBox.information(self, "Info", "No missing instances to run.")
            return

        url, ok = QInputDialog.getText(self, "Game Link", "Enter the game link for all missing instances:")
        if not (ok and url.strip()):
            return

        match = re.search(r"games/(\d+)", url.strip())
        if not match:
            QMessageBox.warning(self, "Error", "Invalid Roblox game link.")
            return

        place_id = match.group(1)
        roblox_command = f'roblox://experience?placeId={place_id}'

        for profile in missing:
            if profile == "Main Profile":
                proc = subprocess.Popen(f'flatpak run org.vinegarhq.Sober "{roblox_command}"', shell=True)
            else:
                profile_path = os.path.join(self.base_dir, profile)
                command = f'env HOME="{profile_path}" flatpak run org.vinegarhq.Sober "{roblox_command}"'
                proc = subprocess.Popen(command, shell=True)
            self.processes[profile] = proc
            self.launched_profiles.add(profile)
        self.updateMissingInstancesLabel()

    def launchMainProfile(self):
        # Count any external Sober instances as running
        if not self._guard_multi_instance(requested_count=1):
            return

        profile = "Main Profile"
        if self.allow_multi_instance and profile in self.processes and self.processes[profile].poll() is None:
            QMessageBox.information(self, "Info", "Main Profile is already running.")
            return
        proc = subprocess.Popen("flatpak run org.vinegarhq.Sober", shell=True)
        self.processes[profile] = proc
        self.launched_profiles.add(profile)
        self.updateMissingInstancesLabel()

    # ------------- Fix selected profiles (any state) -------------

    def fixSelectedProfiles(self):
        targets = list(self.selected_profiles)
        if not targets:
            QMessageBox.information(self, "Info", "Select at least one profile to fix.")
            return

        # Ask for fix method
        msg = QMessageBox(self)
        msg.setWindowTitle("Fix Profiles")
        msg.setText("Which fix method would you prefer?")
        delete_btn = msg.addButton("Delete local files (keeps the data, normally)", QMessageBox.ButtonRole.AcceptRole)
        exit_btn = msg.addButton("Exit", QMessageBox.ButtonRole.RejectRole)
        msg.setIcon(QMessageBox.Icon.Question)
        msg.exec()

        if msg.clickedButton() != delete_btn:
            return

        errors = []
        for profile in targets:
            try:
                self.deleteLocalFilesForProfile(profile)
            except Exception as e:
                errors.append(f"{profile}: {e}")

        if errors:
            QMessageBox.warning(self, "Fix Completed with Errors", "Some profiles could not be fully fixed:\n- " + "\n- ".join(errors))
        else:
            QMessageBox.information(self, "Fix Completed", "Selected profiles were fixed successfully.")

    def deleteLocalFilesForProfile(self, profile):
        # Compute org.vinegarhq.Sober dir for the profile
        if profile == "Main Profile":
            home = os.path.expanduser("~")
            org_dir = os.path.join(home, ".var", "app", "org.vinegarhq.Sober")
        else:
            if not self.base_dir:
                raise RuntimeError("Base directory is not set.")
            profile_path = os.path.join(self.base_dir, profile)
            org_dir = os.path.join(profile_path, ".var", "app", "org.vinegarhq.Sober")

        to_delete = [".ld.so", ".local", "cache"]
        for name in to_delete:
            path = os.path.join(org_dir, name)
            if os.path.exists(path):
                try:
                    if os.path.isdir(path) and not os.path.islink(path):
                        shutil.rmtree(path)
                    else:
                        os.remove(path)
                except Exception as e:
                    raise RuntimeError(f"Failed to delete {name}: {e}")

    # ------------- Nom affiché -------------

    def editDisplayName(self):
        name, ok = QInputDialog.getText(self, "Edit Name", "Enter your name:", text=self.display_name)
        if ok and name.strip():
            self.display_name = name.strip()
            if hasattr(self, "displayNameLabel"):
                self.displayNameLabel.setText(f"Hi, {self.display_name}")
            self.saveSettings()

    def loadDisplayName(self):
        if hasattr(self, "displayNameLabel"):
            self.displayNameLabel.setText(f"Hi, {self.display_name}")

    # ------------- Serveurs privés -------------

    def addPrivateServer(self):
        name, ok1 = QInputDialog.getText(self, "Private Server Name", "Enter a name for the private server:")
        if not ok1 or not name.strip():
            return
        parameter, ok2 = QInputDialog.getText(self, "Parameter", "Enter the parameter:")
        if not ok2 or not parameter.strip():
            return

        name = name.strip()
        parameter = parameter.strip()
        self.privateServers.append((name, parameter))
        self.saveSettings()
        self.refreshPrivateServerButtons()

    def addPrivateServerButtonWidget(self, name, parameter):
        btn = QPushButton(name)
        btn.setMinimumWidth(120)
        btn.clicked.connect(lambda: self.runParameter(parameter))
        btn.setContextMenuPolicy(Qt.ContextMenuPolicy.CustomContextMenu)
        btn.customContextMenuRequested.connect(
            lambda pos, b=btn, n=name, p=parameter: self.showPrivateServerContextMenu(b, n, p)
        )
        self.privateServerButtonsLayout.addWidget(btn)

    def showPrivateServerContextMenu(self, button, name, parameter):
        menu = QMenu()
        remove_action = menu.addAction("Remove")
        edit_action = menu.addAction("Edit")
        action = menu.exec(button.mapToGlobal(button.rect().bottomLeft()))
        if action == remove_action:
            self.removePrivateServerButton(name)
        elif action == edit_action:
            self.editPrivateServerButton(name, parameter)

    def removePrivateServerButton(self, name):
        self.privateServers = [(n, p) for (n, p) in self.privateServers if n != name]
        self.saveSettings()
        self.refreshPrivateServerButtons()

    def editPrivateServerButton(self, old_name, old_parameter):
        name, ok1 = QInputDialog.getText(self, "Edit Private Server Name", "Edit the name:", text=old_name)
        if not ok1 or not name.strip():
            return
        parameter, ok2 = QInputDialog.getText(self, "Edit Parameter", "Edit the parameter:", text=old_parameter)
        if not ok2 or not parameter.strip():
            return
        name = name.strip()
        parameter = parameter.strip()

        updated = []
        for (n, p) in self.privateServers:
            if n == old_name:
                updated.append((name, parameter))
            else:
                updated.append((n, p))
        self.privateServers = updated
        self.saveSettings()
        self.refreshPrivateServerButtons()

    def runParameter(self, parameter):
        command = f'flatpak run org.vinegarhq.Sober "{parameter}"'
        subprocess.Popen(command, shell=True)

    def quickLaunch(self):
        parameter, ok = QInputDialog.getText(self, "Parameter", "Enter the parameter:")
        if not ok or not parameter.strip():
            return
        self.runParameter(parameter.strip())

    def refreshPrivateServerButtons(self):
        # Nettoyer
        if not hasattr(self, "privateServerButtonsLayout"):
            return
        while self.privateServerButtonsLayout.count():
            item = self.privateServerButtonsLayout.takeAt(0)
            w = item.widget()
            if w is not None:
                w.deleteLater()
        # Recréer
        for name, parameter in self.privateServers:
            self.addPrivateServerButtonWidget(name, parameter)

    # ------------- Profile context menu -> Desktop entry -------------

    def showProfileContextMenu(self, pos):
        item = self.profileList.itemAt(pos)
        if not item:
            return
        profile = item.text()
        menu = QMenu()
        add_action = menu.addAction("Add to desktop entry")
        action = menu.exec(self.profileList.mapToGlobal(pos))
        if action == add_action:
            self.createDesktopEntry(profile)

    def createDesktopEntry(self, profile):
        # Resolve desktop directory; fallback to home if Desktop doesn't exist
        home = os.path.expanduser("~")
        desktop_dir = os.path.join(home, "Desktop")
        target_dir = desktop_dir if os.path.isdir(desktop_dir) else home
        os.makedirs(target_dir, exist_ok=True)

        filename = os.path.join(target_dir, f"{profile}.desktop")

        if profile == "Main Profile":
            exec_cmd = "flatpak run org.vinegarhq.Sober"
        else:
            profile_path = os.path.join(self.base_dir, profile)
            exec_cmd = f'env HOME="{profile_path}" flatpak run org.vinegarhq.Sober'

        icon_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "SoberLauncher.svg")

        content = f"""[Desktop Entry]
Type=Application
Name={profile}
Exec={exec_cmd}
Icon={icon_path}
Terminal=false
"""
        try:
            with open(filename, "w", encoding="utf-8") as f:
                f.write(content)
            os.chmod(filename, 0o755)
            QMessageBox.information(self, "Desktop Entry", f"Created {filename}")
        except Exception as e:
            QMessageBox.critical(self, "Desktop Entry", f"Failed to create {filename}:\n{e}")

    # ------------- UI -------------

    def initUI(self):
        self.main_tab_widget = QTabWidget()

        # Barre globale (placeholder)
        global_top_bar = QHBoxLayout()
        global_top_bar.addStretch(1)

        # ----- Onglet Instances -----
        instances_tab = QWidget()
        self.instances_layout = QVBoxLayout(instances_tab)

        main_layout = QHBoxLayout()
        left_layout = QVBoxLayout()

        top_bar = QHBoxLayout()
        self.selectDirButton = QPushButton("Select Base Directory")
        self.selectDirButton.clicked.connect(self.selectDirectory)
        top_bar.addWidget(self.selectDirButton)

        self.refreshButton = QPushButton()
        self.refreshButton.setIcon(QIcon.fromTheme("view-refresh"))
        self.refreshButton.setToolTip("Refresh Profiles")
        self.refreshButton.clicked.connect(self.scanForProfiles)
        top_bar.addWidget(self.refreshButton)

        self.createProfileButton = QPushButton("Create Profile")
        self.createProfileButton.clicked.connect(self.createProfile)
        top_bar.addWidget(self.createProfileButton)

        # Exit button label depends on multi-instance
        self.exitAllButton = QPushButton("Exit Current Session" if not self.allow_multi_instance else "Exit All Sessions")
        self.exitAllButton.clicked.connect(self.exitAllSessions)
        top_bar.addWidget(self.exitAllButton)

        self.removeCrashButton = QPushButton("Remove Crash")
        self.removeCrashButton.clicked.connect(self.removeCrashWindows)
        top_bar.addWidget(self.removeCrashButton)

        self.aboutButtonInstances = QPushButton("About")
        self.aboutButtonInstances.clicked.connect(self.showAbout)
        top_bar.addWidget(self.aboutButtonInstances)

        left_layout.addLayout(top_bar)

        self.profileList = QListWidget()
        self.profileList.setSelectionMode(QAbstractItemView.SelectionMode.ExtendedSelection)
        self.profileList.itemSelectionChanged.connect(self.updateSelectedProfiles)
        # Add context menu for desktop entry
        self.profileList.setContextMenuPolicy(Qt.ContextMenuPolicy.CustomContextMenu)
        self.profileList.customContextMenuRequested.connect(self.showProfileContextMenu)

        left_layout.addWidget(self.profileList)

        right_layout = QVBoxLayout()
        right_layout.setContentsMargins(0, 0, 0, 0)
        right_layout.setSpacing(10)

        self.selectedProfileLabel = QLabel("Selected Profiles: None")
        self.selectedProfileLabel.setWordWrap(True)
        self.selectedProfileLabel.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        right_layout.addWidget(self.selectedProfileLabel)

        self.launchButton = QPushButton("Launch Game")
        self.launchButton.clicked.connect(self.launchGame)
        right_layout.addWidget(self.launchButton)

        self.consoleLaunchButton = QPushButton("Run with Console")
        self.consoleLaunchButton.clicked.connect(self.runWithConsole)
        right_layout.addWidget(self.consoleLaunchButton)

        self.runSpecificGameButton = QPushButton("Run Specific Game")
        self.runSpecificGameButton.clicked.connect(self.runSpecificGame)
        right_layout.addWidget(self.runSpecificGameButton)

        # Fix button (works for any selected profiles)
        self.fixButton = QPushButton("Fix")
        self.fixButton.setToolTip("Fix selected profiles (delete local files)")
        self.fixButton.clicked.connect(self.fixSelectedProfiles)
        right_layout.addWidget(self.fixButton)

        right_panel_widget = QWidget()
        right_panel_widget.setLayout(right_layout)
        right_panel_widget.setFixedWidth(300)

        main_layout.addLayout(left_layout)
        main_layout.addWidget(right_panel_widget)

        # Bottom layout (missing instances bar)
        self.bottom_layout = QHBoxLayout()
        self.missingInstancesLabel = QLabel("Instances not running: None")
        self.missingInstancesLabel.setWordWrap(True)
        self.missingInstancesLabel.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)
        self.bottom_layout.addWidget(self.missingInstancesLabel)

        self.runMissingButton = QPushButton("Run Missing Instances")
        self.runMissingButton.clicked.connect(self.runMissingInstances)
        self.bottom_layout.addWidget(self.runMissingButton)

        self.runMissingWithLinkButton = QPushButton()
        self.runMissingWithLinkButton.setIcon(QIcon.fromTheme("internet-web-browser"))
        self.runMissingWithLinkButton.setToolTip("Run Missing Instances with Game Link")
        self.runMissingWithLinkButton.clicked.connect(self.runMissingInstancesWithLink)
        self.bottom_layout.addWidget(self.runMissingWithLinkButton)

        # Add main and bottom sections
        self.instances_layout.addLayout(main_layout)
        # Add bottom layout only when multi-instance is enabled
        if self.allow_multi_instance:
            self.instances_layout.addLayout(self.bottom_layout)
            self.bottom_layout_added = True
        else:
            self.bottom_layout_added = False

        instances_tab.setLayout(self.instances_layout)

        # ----- Roblox Player tab (created once; visibility controlled by toggle) -----
        self.roblox_tab = QWidget()
        roblox_layout = QVBoxLayout()
        self.roblox_tab.setLayout(roblox_layout)

        roblox_layout.addStretch(2)

        name_row = QHBoxLayout()
        self.displayNameLabel = QLabel(f"Hi, {self.display_name}")
        self.displayNameLabel.setAlignment(Qt.AlignmentFlag.AlignHCenter | Qt.AlignmentFlag.AlignVCenter)
        font = self.displayNameLabel.font()
        font.setPointSize(32)
        font.setBold(True)
        self.displayNameLabel.setFont(font)
        name_row.addWidget(self.displayNameLabel)

        pencil_btn = QPushButton()
        pencil_btn.setIcon(QIcon.fromTheme("document-edit"))
        pencil_btn.setFixedSize(32, 32)
        pencil_btn.setToolTip("Edit name")
        pencil_btn.clicked.connect(self.editDisplayName)
        name_row.addWidget(pencil_btn)

        name_row.addStretch(1)
        roblox_layout.addLayout(name_row)

        roblox_layout.addStretch(1)

        play_button = QPushButton("Play")
        play_button.setFixedHeight(60)
        play_button.setStyleSheet("font-size: 20px;")
        play_button.clicked.connect(self.launchMainProfile)
        roblox_layout.addWidget(play_button, alignment=Qt.AlignmentFlag.AlignHCenter | Qt.AlignmentFlag.AlignVCenter)

        button_row = QHBoxLayout()
        self.addPrivateServerButton = QPushButton("Add private server")
        self.addPrivateServerButton.clicked.connect(self.addPrivateServer)
        button_row.addWidget(self.addPrivateServerButton)

        self.quickLaunchButton = QPushButton("Quick launch")
        self.quickLaunchButton.clicked.connect(self.quickLaunch)
        button_row.addWidget(self.quickLaunchButton)

        self.privateServerButtonsLayout = QHBoxLayout()
        button_row.addLayout(self.privateServerButtonsLayout)
        button_row.addStretch(1)

        roblox_layout.addLayout(button_row)
        roblox_layout.addStretch(6)

        # Recharger nom et serveurs privés
        QTimer.singleShot(0, self.loadDisplayName)
        QTimer.singleShot(0, self.refreshPrivateServerButtons)

        # Tabs: always add Instances; Roblox tab added conditionally
        self.main_tab_widget.addTab(instances_tab, "Instances")
        if self.roblox_player_enabled:
            self.main_tab_widget.addTab(self.roblox_tab, "Roblox Player")

        # Hide tab bar if only one tab visible
        self.updateRobloxTabVisibility()

        # Layout wrapper
        wrapper_layout = QVBoxLayout()
        wrapper_layout.addLayout(global_top_bar)
        wrapper_layout.addWidget(self.main_tab_widget)
        self.setLayout(wrapper_layout)

        self.setWindowTitle("Sober Launcher")
        self.setWindowIcon(QIcon(os.path.join(os.path.dirname(os.path.abspath(__file__)), "SoberLauncher.svg")))

        # Apply startup window mode (maximize/fullscreen depending on environment)
        self.applyWindowStartupMode()

        # Ensure the UI reflects current multi-instance setting
        QTimer.singleShot(0, self.applyMultiInstanceUIState)

    def applyMultiInstanceUIState(self):
        # Update exit button label
        if hasattr(self, "exitAllButton"):
            self.exitAllButton.setText("Exit All Sessions" if self.allow_multi_instance else "Exit Current Session")

        # Add/remove bottom layout from instances_layout so it truly appears/disappears
        if self.allow_multi_instance and not self.bottom_layout_added:
            self.instances_layout.addLayout(self.bottom_layout)
            self.bottom_layout_added = True
        elif not self.allow_multi_instance and self.bottom_layout_added:
            # Remove bottom layout by hiding its widgets and detaching it
            for i in range(self.bottom_layout.count()):
                item = self.bottom_layout.itemAt(i)
                w = item.widget()
                if w:
                    w.hide()
            # Note: Qt doesn't provide removeLayout directly; using setParent(None) to detach
            container = QWidget()
            temp_layout = QVBoxLayout(container)
            temp_layout.addLayout(self.bottom_layout)
            container.setParent(None)
            self.bottom_layout_added = False

        # Update missing label immediately if enabled; clear highlighting if disabled
        if self.allow_multi_instance:
            self.updateMissingInstancesLabel()
            # Ensure widgets visible
            for i in range(self.bottom_layout.count()):
                item = self.bottom_layout.itemAt(i)
                w = item.widget()
                if w:
                    w.show()
        else:
            self.colorizeMissingProfiles(missing=[])
            if hasattr(self, "missingInstancesLabel"):
                self.missingInstancesLabel.setText("Launched instances not running: None")

    # ------------- Startup window mode -------------

    def applyWindowStartupMode(self):
        # Ensure fullscreen on Steam Deck Gaming Mode (gamescope)
        desktop = os.environ.get("XDG_CURRENT_DESKTOP", "").lower()
        if "gamescope" in desktop or os.environ.get("STEAMDECK", "") == "1":
            self.showFullScreen()
        else:
            self.showMaximized()

    # ------------- Sélection et dossiers -------------

    def selectDirectory(self):
        dir_selected = QFileDialog.getExistingDirectory(self, "Select Base Directory")
        if dir_selected:
            self.base_dir = os.path.abspath(dir_selected)
            self.saveSettings()
            QMessageBox.information(self, "Directory Selected", f"Base Directory: {self.base_dir}")
            self.scanForProfiles()

    def updateSelectedProfiles(self):
        self.selected_profiles = [item.text() for item in self.profileList.selectedItems()]
        self.selectedProfileLabel.setText(
            f"Selected Profiles: {', '.join(self.selected_profiles) if self.selected_profiles else 'None'}"
        )


def apply_dark_blue_theme_if_no_theme(app: QApplication):
    # If no icon theme is set, assume no theme and apply a dark blue Fusion palette
    if not QIcon.themeName():
        app.setStyle("Fusion")
        palette = QPalette()

        # Base colors
        dark_gray = QColor(30, 30, 30)
        mid_gray = QColor(45, 45, 45)
        light_gray = QColor(200, 200, 200)
        text_gray = QColor(220, 220, 220)
        blue = QColor("#1e3a8a")  # dark blue highlight

        palette.setColor(QPalette.ColorRole.Window, dark_gray)
        palette.setColor(QPalette.ColorRole.WindowText, text_gray)
        palette.setColor(QPalette.ColorRole.Base, QColor(25, 25, 25))
        palette.setColor(QPalette.ColorRole.AlternateBase, mid_gray)
        palette.setColor(QPalette.ColorRole.ToolTipBase, light_gray)
        palette.setColor(QPalette.ColorRole.ToolTipText, QColor(20, 20, 20))
        palette.setColor(QPalette.ColorRole.Text, text_gray)
        palette.setColor(QPalette.ColorRole.Button, mid_gray)
        palette.setColor(QPalette.ColorRole.ButtonText, text_gray)
        palette.setColor(QPalette.ColorRole.BrightText, QColor(255, 0, 0))
        palette.setColor(QPalette.ColorRole.Link, QColor("#60a5fa"))
        palette.setColor(QPalette.ColorRole.Highlight, blue)
        palette.setColor(QPalette.ColorRole.HighlightedText, QColor(240, 240, 240))
        app.setPalette(palette)


if __name__ == "__main__":
    app = QApplication(sys.argv)

    # Apply dark blue theme automatically if no theme is detected
    apply_dark_blue_theme_if_no_theme(app)

    window = SoberLauncher()
    # No window.show() here; applyWindowStartupMode decides showFullScreen/showMaximized
    sys.exit(app.exec())
