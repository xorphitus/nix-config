{ config, pkgs, ... }:

{
  home.username = "xorphitus";
  home.homeDirectory = "/home/xorphitus";

  home.stateVersion = "24.11";

  home.file.".config/environment.d/00-my.conf".text = ''
    # IME
    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    XMODIFIERS=@im=fcitx

    # GPG
    GPG_TTY=$(tty)
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';


  xdg.enable = true;
  xdg.configFile."autostart/fcitx5.desktop".source = "${pkgs.fcitx5}/share/applications/fcitx5.desktop";
}
