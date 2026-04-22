{ palette }:
''
  * {
      font-family: "Ricty Discord Nerd Font", monospace;
      font-size: 13px;
      min-height: 0;
      border: none;
      border-radius: 0;
  }

  window#waybar {
      background: transparent;
      color: ${palette.nord6};
  }

  #workspaces,
  #mode,
  #clock,
  #cpu,
  #memory,
  #temperature,
  #network,
  #pulseaudio,
  #tray,
  #idle_inhibitor,
  #battery,
  #backlight,
  #power-profiles-daemon,
  #keyboard-state,
  #custom-media,
  #custom-swaync,
  #custom-pomodoro-el {
      background: rgba(${palette.nord0rgb}, 0.8);
      color: ${palette.nord6};
      padding: 0 10px;
      margin: 4px 2px;
      border-radius: 12px;
      border: 1px solid rgba(${palette.nord3rgb}, 0.5);
  }

  #workspaces button {
      padding: 0 6px;
      margin: 2px 2px;
      color: ${palette.nord3};
      background: transparent;
      border: none;
      border-radius: 8px;
  }

  #workspaces button.active {
      color: ${palette.nord6};
      background: rgba(${palette.nord8rgb}, 0.4);
  }

  #workspaces button:hover {
      background: rgba(${palette.nord3rgb}, 0.4);
      box-shadow: none;
      text-shadow: none;
  }

  #temperature.critical {
      background: rgba(${palette.nord11rgb}, 0.8);
  }

  #battery.warning {
      background: rgba(${palette.nord13rgb}, 0.8);
      color: ${palette.nord0};
  }

  #battery.critical {
      background: rgba(${palette.nord11rgb}, 0.8);
  }

  #idle_inhibitor.activated {
      color: ${palette.nord13};
  }

  tooltip {
      background: rgba(${palette.nord1rgb}, 0.95);
      border: 1px solid rgba(${palette.nord3rgb}, 0.5);
      border-radius: 12px;
  }

  tooltip label {
      color: ${palette.nord6};
  }
''
