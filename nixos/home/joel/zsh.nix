{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";

    fileWidget = {
      command = "fd --hidden --strip-cwd-prefix --exclude .git";
      options = [
        "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
      ];
    };

    changeDirWidget = {
      command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      options = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 5000;
      save = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      append = true;
      share = true;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "command-not-found"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/joel/dotfiles/nixos#mainframe";
      rebuild-test = "sudo nixos-rebuild test --flake /home/joel/dotfiles/nixos#mainframe";
      update-system = "cd /home/joel/dotfiles/nixos && nix flake update && sudo nixos-rebuild switch --flake .#mainframe";
      nix-clean = "sudo nix-collect-garbage --delete-older-than 14d";
      ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
      ll = "eza --color=always --long --git --icons=always";
      cat = "bat";
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      ff = ''nvim $(fzf -m --preview="bat --color=always {}")'';
      fastfetch = "fastfetch --config examples/13";
      "ös" = "ls";
      sl = "ls";
      c = "clear";
    };

    initContent = lib.mkOrder 1000 ''
      [[ -f "''${ZDOTDIR:-$HOME}/.p10k.zsh" ]] && source "''${ZDOTDIR:-$HOME}/.p10k.zsh"
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always $realpath | head -200'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --color=always $realpath | head -200'
    '';
  };
}
