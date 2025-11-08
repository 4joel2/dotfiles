
# --- 1. Antidote & Zephyr Bootstrap ---

# Lade Antidote (installiert via git clone)
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Konfiguriere Zephyr-Module, *bevor* Zephyr geladen wird.
zstyle ':zephyr:modules' list 'keyboard' 'utility' 'completions'
# Lade alle Plugins aus der .zsh_plugins.txt Datei
# Antidote Plugins laden und cachen
antidote load ${ZDOTDIR:-~}/.zsh_plugins.txt
source ${ZDOTDIR:-~}/.zsh_plugins.zsh

eval "$(oh-my-posh init zsh --config honukai)"

# --- 4. PATH & FZF Umgebung ---

export PATH=$HOME/.local/bin:$HOME/Dokumente/hacking/programs:$PATH

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_ALT_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# --- 5. Aliase ---

alias zshconfig="vim ~/.zshrc"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias gc="git commit -m"
alias gp="git push"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat"
alias ll="eza --color=always --long --git --icons=always -a"
alias z="zathura --fork"
alias ös="ls"
alias sl="ls"
alias sqlmap="~/Dokumente/hacking/programs/sqlmap-dev/sqlmap.py"
alias ff='nvim $(fzf -m --preview="bat --color=always {}")'

# --- 6. Lazy-Loading Funktionen ---
# Alle Einrückungen mit normalen Leerzeichen korrigiert

autoload -U add-zsh-hook

# Lazy FZF Initialisierung
_lazy_fzf_init() {
    add-zsh-hook -d precmd _lazy_fzf_init
    eval "$(fzf --zsh)"
}
add-zsh-hook precmd _lazy_fzf_init

# Lazy-load fzf-git.sh
_lazy_fzf_git() {
    add-zsh-hook -d precmd _lazy_fzf_git
    source ~/fzf-git.sh/fzf-git.sh
}
add-zsh-hook precmd _lazy_fzf_git

# Lazy Conda Initialisierung
start_conda() {
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate base
}
alias conda-init='source ~/miniconda3/etc/profile.d/conda.sh'

echo -ne '\e[2 q'
