{ palette }:
''
  configuration {
      modi: "window,drun,system:~/.local/bin/rofi_system.sh";
      sidebar-mode: true;
      hide-scrollbar: true;
      kb-cancel: "Escape";
  }

  * {
      font:                        "Ricty Discord Nerd Font 13";
      foreground:                  ${palette.nord6};
      normal-foreground:           @foreground;
      alternate-normal-foreground: @foreground;
      selected-normal-foreground:  ${palette.nord6};
      selected-normal-background:  ${palette.nord8}66;
      normal-background:           transparent;
      alternate-normal-background: transparent;
      active-foreground:           ${palette.nord8};
      alternate-active-foreground: @active-foreground;
      selected-active-foreground:  ${palette.nord0};
      active-background:           ${palette.nord3};
      alternate-active-background: transparent;
      selected-active-background:  ${palette.nord8}66;
      urgent-foreground:           ${palette.nord11};
      alternate-urgent-foreground: @urgent-foreground;
      selected-urgent-foreground:  ${palette.nord6};
      urgent-background:           transparent;
      alternate-urgent-background: transparent;
      selected-urgent-background:  ${palette.nord11}66;
      background:                  transparent;
      background-color:            transparent;
      bordercolor:                 ${palette.nord3};
      border-color:                ${palette.nord3}80;
      separatorcolor:              ${palette.nord3}80;
      spacing:                     2;
  }
  window {
      background-color: ${palette.nord0}cc;
      border:           1;
      border-color:     ${palette.nord3};
      border-radius:    12;
      padding:          5;
  }
  mainbox {
      border:  0;
      padding: 0;
  }
  message {
      border:       1px dash 0px 0px ;
      border-color: @separatorcolor;
      padding:      1px ;
  }
  textbox {
      text-color: @foreground;
  }
  listview {
      fixed-height:  0;
      border:        2px dash 0px 0px ;
      border-color:  @separatorcolor;
      spacing:       2px ;
      scrollbar:     true;
      padding:       2px 0px 0px ;
      border-radius: 12;
  }
  element {
      border:  0;
      padding: 1px ;
  }
  element-text {
      background-color: inherit;
      text-color:       inherit;
  }
  element.normal.normal {
      background-color: @normal-background;
      text-color:       @normal-foreground;
  }
  element.normal.urgent {
      background-color: @urgent-background;
      text-color:       @urgent-foreground;
  }
  element.normal.active {
      background-color: @active-background;
      text-color:       @active-foreground;
  }
  element.selected.normal {
      background-color: @selected-normal-background;
      text-color:       @selected-normal-foreground;
      border-radius:    8;
  }
  element.selected.urgent {
      background-color: @selected-urgent-background;
      text-color:       @selected-urgent-foreground;
      border-radius:    8;
  }
  element.selected.active {
      background-color: @selected-active-background;
      text-color:       @selected-active-foreground;
      border-radius:    8;
  }
  element.alternate.normal {
      background-color: @alternate-normal-background;
      text-color:       @alternate-normal-foreground;
  }
  element.alternate.urgent {
      background-color: @alternate-urgent-background;
      text-color:       @alternate-urgent-foreground;
  }
  element.alternate.active {
      background-color: @alternate-active-background;
      text-color:       @alternate-active-foreground;
  }
  scrollbar {
      width:        4px ;
      border:       0;
      handle-width: 8px ;
      padding:      0;
  }
  mode-switcher {
      border:        2px dash 0px 0px ;
      border-color:  @separatorcolor;
      border-radius: 12;
  }
  button.selected {
      background-color: @selected-normal-background;
      text-color:       @selected-normal-foreground;
  }
  button {
      background-color: @background;
      text-color:       @foreground;
  }
  inputbar {
      spacing:    0;
      text-color: @normal-foreground;
      padding:    1px ;
      children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
  }
  case-indicator {
      spacing:    0;
      text-color: @normal-foreground;
  }
  entry {
      spacing:    0;
      text-color: @normal-foreground;
  }
  prompt {
      spacing:    0;
      text-color: @normal-foreground;
  }
  textbox-prompt-colon {
      expand:     false;
      str:        ":";
      margin:     0px 0.3em 0em 0em ;
      text-color: @normal-foreground;
  }
''
