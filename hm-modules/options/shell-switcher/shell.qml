//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
  id: root

  readonly property string targetMonitor: Quickshell.env("SHELL_SWITCHER_MONITOR") || ""
  readonly property string currentProfile: Quickshell.env("SHELL_SWITCHER_ACTIVE") || "noctalia"
  readonly property string dispatcher: Quickshell.env("SHELL_SWITCHER_SCRIPT") || "shell-selector"

  property var profiles: [
    { pid: "noctalia", label: "Noctalia", color: "#FFF59B", bg: "#0E0E43", icon: Qt.resolvedUrl("assets/noctalia.svg") },
    { pid: "caelestia", label: "Caelestia", color: "#6AE5E1", bg: "#1a1930", icon: Qt.resolvedUrl("assets/caelestia.svg") },
    { pid: "dms", label: "DMS", color: "#42A5F5", bg: "#101418", icon: Qt.resolvedUrl("assets/dms.svg") }
  ]

  readonly property var screens: {
    var available = Quickshell.screens || [];
    if (!targetMonitor) return available.length > 0 ? [available[0]] : [];
    for (var i = 0; i < available.length; i++) {
      if (available[i].name === targetMonitor) return [available[i]];
    }
    return available.length > 0 ? [available[0]] : [];
  }

  function idx(id) {
    for (var i = 0; i < profiles.length; i++) {
      if (profiles[i].pid === id) return i;
    }
    return 0;
  }

  function pick(pid) {
    Quickshell.execDetached(["bash", dispatcher, "switch", pid]);
    Qt.quit();
  }
  Variants {
    model: root.screens

    PanelWindow {
      id: panel

      required property ShellScreen modelData
      screen: modelData
      visible: true
      color: "transparent"

      anchors.top: true
      anchors.left: true
      anchors.right: true
      anchors.bottom: true

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      WlrLayershell.namespace: "shell-switcher-" + modelData.name
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      property int hover: root.idx(root.currentProfile)

      Item {
        anchors.fill: parent
        focus: true
        Component.onCompleted: forceActiveFocus()

        Keys.onPressed: (ev) => {
          if (ev.key === Qt.Key_Escape) Qt.quit();
          else if (ev.key === Qt.Key_Left) { hover = (hover - 1 + root.profiles.length) % root.profiles.length; ev.accepted = true; }
          else if (ev.key === Qt.Key_Right) { hover = (hover + 1) % root.profiles.length; ev.accepted = true; }
          else if (ev.key === Qt.Key_Return || ev.key === Qt.Key_Enter) { root.pick(root.profiles[hover].pid); ev.accepted = true; }
          else if (ev.key === Qt.Key_1) { root.pick(root.profiles[0].pid); ev.accepted = true; }
          else if (ev.key === Qt.Key_2) { root.pick(root.profiles[1].pid); ev.accepted = true; }
          else if (ev.key === Qt.Key_3) { root.pick(root.profiles[2].pid); ev.accepted = true; }
        }

        Rectangle { anchors.fill: parent; color: "#0a0e1a"; opacity: 0.7 }

        Row {
          anchors.centerIn: parent
          spacing: 20

          Repeater {
            model: root.profiles
            delegate: MouseArea {
              width: 220
              height: 190
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.pick(modelData.pid)
              onEntered: panel.hover = index

              Rectangle {
                id: card
                anchors.fill: parent
                radius: 18
                color: panel.hover === index ? Qt.lighter(modelData.bg, 1.4) : modelData.bg
                border.width: root.currentProfile === modelData.pid ? 2 : (panel.hover === index ? 2 : 1)
                border.color: root.currentProfile === modelData.pid ? modelData.color : (panel.hover === index ? modelData.color : "#444466")
                scale: panel.hover === index ? 1.04 : 1.0

                Behavior on color { ColorAnimation { duration: 120 } }
                Behavior on border.color { ColorAnimation { duration: 120 } }
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                Column {
                  anchors.fill: parent
                  anchors.margins: 16
                  spacing: 8

                  Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 80
                    height: 80
                    fillMode: Image.PreserveAspectFit
                    source: modelData.icon
                    mipmap: true
                  }

                  Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.label
                    color: panel.hover === index ? "#ffffff" : "#ccccee"
                    font.pixelSize: 16
                    font.family: "monospace"
                    font.bold: true
                  }

                  Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.currentProfile === modelData.pid ? 50 : 0
                    height: 3
                    radius: 1.5
                    color: modelData.color
                    Behavior on width { NumberAnimation { duration: 120 } }
                  }

                  Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: (index + 1).toString()
                    color: modelData.color
                    font.pixelSize: 12
                    font.family: "monospace"
                    opacity: 0.7
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}