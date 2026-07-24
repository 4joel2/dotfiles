{ pkgs, ... }:

{
  programs.mango = {
    enable = true;
    addLoginEntry = true;
  };

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd mango";
      user = "greeter";
    };
  };

  security.polkit.enable = true;

  services.dbus.enable = true;
  programs.dconf.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config.common.default = [
      "wlr"
      "gtk"
    ];
  };

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    playerctl
    libnotify

    wl-clipboard
    cliphist

    grim
    slurp
    swappy

    xdg-utils
    file
    unzip
    zip
    p7zip

    networkmanagerapplet
  ];
}
