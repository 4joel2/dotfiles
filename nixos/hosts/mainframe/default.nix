{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "mainframe";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  console.keyMap = "de";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  users.users.joel = {
    isNormalUser = true;
    description = "Joel";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = true;

  programs.zsh.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;

      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
  ];

  services.fstrim.enable = true;
  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;

  services.openssh = {
    enable = false;
    openFirewall = false;
  };

  networking.firewall.enable = true;

  system.stateVersion = "26.05";
}
