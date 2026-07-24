{ pkgs, inputs, ... }:

{
  imports = [
    ./zsh.nix
    ./mango.nix
    ./ghostty.nix
    ./ssh.nix
    inputs.noctalia.homeModules.default
    inputs.pi.homeModules.default
    inputs.helium-browser.homeModules.default
  ];

  home = {
    username = "joel";
    homeDirectory = "/home/joel";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  programs.noctalia = {
    enable = true;
  };

  programs.pi.coding-agent = {
    enable = true;
  };
  programs.helium = {
    enable = true;
    flags = [
      "--ozone-platform-hint=auto"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
      "x-scheme-handler/about" = [ "helium.desktop" ];
      "x-scheme-handler/unknown" = [ "helium.desktop" ];
    };
  };

  home.sessionVariables.BROWSER = "helium";

  home.packages = with pkgs; [
    firefox
    foot
    fuzzel
    nautilus
    btop
    fastfetch
    ripgrep
    fd
    jq
    tree
    eza
    bat
    neovim
    vesktop
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Joel";
      user.email = "mantikjoel@pm.me";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };




  programs.fuzzel = {
    enable = true;
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  xdg.enable = true;
}
