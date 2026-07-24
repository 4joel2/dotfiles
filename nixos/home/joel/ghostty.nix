{ config, pkgs, ... }:

{
  # Die Schrift aus der bisherigen Ghostty-Konfiguration.
  home.packages = [
    pkgs.nerd-fonts.geist-mono
  ];

  # Ghostty 1.3 bevorzugt config.ghostty. Das Home-Manager-Modul erzeugt
  # derzeit noch "config", daher verweisen beide Namen auf dieselbe Datei.
  xdg.configFile."ghostty/config.ghostty".source =
    config.xdg.configFile."ghostty/config".source;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Schrift
      font-family = "GeistMono Nerd Font";
      font-size = 20;

      # Fenster
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;
      background-opacity = 0.9;
      background-blur = true;
      gtk-titlebar = false;
      gtk-single-instance = true;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;

      # Verlauf und Bedienung
      scrollback-limit = 3023;
      mouse-hide-while-typing = true;
      copy-on-select = false;
      confirm-close-surface = false;
      app-notifications = "no-clipboard-copy,no-config-reload";

      # Splits
      unfocused-split-opacity = 0.5;
      unfocused-split-fill = "#44464f";

      # Shell-Integration
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,no-cursor";

      # Das in der bisherigen Hauptkonfiguration aktive Theme.
      theme = "noctalia";

      keybind = [
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "shift+enter=text:\\n"
      ];
    };

    # Die beiden zusätzlichen Farbschemata aus deinem Dotfiles-Repository.
    # Aktivieren kannst du sie später mit theme = "dankcolors" bzw.
    # theme = "dankcolors-material".
    themes = {
      dankcolors = {
        background = "#232136";
        foreground = "#e0def4";
        cursor-color = "#c4a7e7";
        selection-background = "#26233a";
        selection-foreground = "#e0def4";
        palette = [
          "0=#2a273f"
          "1=#ff728c"
          "2=#73e78d"
          "3=#ffdb72"
          "4=#b392db"
          "5=#4d346a"
          "6=#c4a7e7"
          "7=#eae3f2"
          "8=#908a96"
          "9=#ff9fb1"
          "10=#a5ffba"
          "11=#ffe8a5"
          "12=#ddc2fe"
          "13=#e3cdff"
          "14=#eddfff"
          "15=#fbf8ff"
        ];
      };

      dankcolors-material = {
        background = "#1d0f15";
        foreground = "#f7dbe4";
        cursor-color = "#ffb0ce";
        selection-background = "#ff44a5";
        selection-foreground = "#f7dbe4";
        palette = [
          "0=#1d0f15"
          "1=#d35e38"
          "2=#6ed685"
          "3=#cddb7b"
          "4=#ce5c86"
          "5=#bf8fa1"
          "6=#ffb0ce"
          "7=#abb2bf"
          "8=#5c6370"
          "9=#e07e5f"
          "10=#86e09a"
          "11=#dce897"
          "12=#ffbcdc"
          "13=#b7598d"
          "14=#ad6376"
          "15=#ffffff"
        ];
      };
    };
  };
}
