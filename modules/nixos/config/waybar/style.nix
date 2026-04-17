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
      background: ${palette.nord0}cc;
      color: ${palette.nord6};
      padding: 0 10px;
      margin: 4px 2px;
      border-radius: 12px;
      border: 1px solid ${palette.nord3}80;
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
      background: ${palette.nord8}66;
  }

  #workspaces button:hover {
      background: ${palette.nord3}66;
      box-shadow: none;
      text-shadow: none;
  }

  #temperature.critical {
      background: ${palette.nord11}cc;
  }

  #battery.warning {
      background: ${palette.nord13}cc;
      color: ${palette.nord0};
  }

  #battery.critical {
      background: ${palette.nord11}cc;
  }

  #idle_inhibitor.activated {
      color: ${palette.nord13};
  }

  tooltip {
      background: ${palette.nord1}f2;
      border: 1px solid ${palette.nord3}80;
      border-radius: 12px;
  }

  tooltip label {
      color: ${palette.nord6};
  }
''
