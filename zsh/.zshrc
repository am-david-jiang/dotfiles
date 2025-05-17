# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jiang/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Alias configuration
alias ls='eza --color=auto --icons=auto'
alias ll='ls -l'
alias l.='ls -Al'
alias grep='grep --color=auto'

# Proxy env configuration
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
export all_proxy='http://127.0.0.1:7890'

# where should we download your Zsh plugins?
#ZPLUGINDIR=$ZDOTDIR/plugins

## Clone a plugin, identify its init file, source it, and add it to your fpath.
function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

# make a github repo plugins list
plugins=(
  sindresorhus/pure
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  # marlonrichert/zsh-autocomplete

  # load these at hypersonic load speeds with zsh-defer
  romkatv/zsh-defer
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
)
plugin-load $plugins

# Nvm path environment variable config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Starship prompt config
# eval "$(starship init zsh)"

# Created by `pipx` on 2024-05-03 15:56:13
export PATH="$PATH:/home/jiang/.local/bin"

# Cargo
. "$HOME/.cargo/env"

# bun completions
[ -s "/home/jiangqiang/.bun/_bun" ] && source "/home/jiangqiang/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Created by `pipx` on 2025-03-08 04:31:24
export PATH="$PATH:/home/jiangqiang/.local/bin"

# pnpm
export PNPM_HOME="/home/jiangqiang/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [[ "$TERM" = "xterm-kitty" ]] && [[ -z "$ZELLIJ" ]]; then
  zellij attach general-workspace

  if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
    exit
  fi
fi
