wm

# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Manual configuration

PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
PATH=$PATH:/opt/4rji/bin
# Custom Aliases

alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='/bin/batcat --paging=never'
alias catn='cat'
alias catnl='batcat'


# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Functions
function mkt(){
    mkdir "$1" && cd "$1" && mkdir nmap && mkdir content && mkdir exploits && mkdir scripts && echo 'nuevo directorio' && pwd && ls
}


# Con la funcion de que se puede poner un nombre despues del mktem para especificar el nombre del folder.
function mktem() {
    if [ -n "$1" ]; then
        new_dir=$(mktemp -d /dev/shm/tmp."$1".XXXXXX)
    else
        new_dir=$(mktemp -d /dev/shm/tmp.XXXXXX)
    fi
    
    echo "Directorio creado en: $new_dir"
    cd "$new_dir" || return
    echo "Cambiado al directorio: $PWD"
}


function mktemm() {
    if [ -n "$1" ]; then
        new_dir=$(mktemp -d /tmp/tmp."$1".XXXXXX)
    else
        new_dir=$(mktemp -d /tmp/tmp.XXXXXX)
    fi
    
    echo "Directorio creado en: $new_dir"
    cd "$new_dir" || return
    echo "Cambiado al directorio: $PWD"
}



# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}


# Settarget

function settarget(){
	if [ $# -eq 1 ]; then
	echo $1 > ~/.config/bin/target
	elif [ $# -gt 2 ]; then
	echo "settarget [IP] [NAME] | settarget [IP]"
	else
	echo $1 $2 > ~/.config/bin/target
	fi
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}







# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	                echo {} is a binary file ||
	                 (bat --style=numbers --color=always {} ||
	                  highlight -O ansi -l {} ||
	                  coderay {} ||
	                  rougify {} ||
	                  cat {}) 2> /dev/null | head -500'

	else
	        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                         echo {} is a binary file ||
	                         (bat --style=numbers --color=always {} ||
	                          highlight -O ansi -l {} ||
	                         coderay {} ||
	                          rougify {} ||
	                          cat {}) 2> /dev/null | head -500'
	fi
}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}


function mktem() {
    if [ -n "$1" ]; then
        new_dir=$(mktemp -d /dev/shm/tmp."$1".XXXXXX)
    else
        new_dir=$(mktemp -d /dev/shm/tmp.XXXXXX)
    fi
    echo "Directorio creado en: $new_dir"
    cd "$new_dir" || return
    echo "Cambiado al directorio: $PWD"
}

function mktemm() {
    if [ -n "$1" ]; then
        new_dir=$(mktemp -d /tmp/tmp."$1".XXXXXX)
    else
        new_dir=$(mktemp -d /tmp/tmp.XXXXXX)
    fi
    echo "Directorio creado en: $new_dir"
    cd "$new_dir" || return
    echo "Cambiado al directorio: $PWD"
}

function __fzf_history_search() {
  local selected
  selected=$(fc -rl 1 | fzf --tac +s --tiebreak=index --toggle-sort=ctrl-r | awk '{$1=""; sub("  ", ""); print}')
  if [[ -n $selected ]]; then
    LBUFFER="$selected"
    RBUFFER=""
  fi
  zle reset-prompt
}

zle -N __fzf_history_search
bindkey '^R' __fzf_history_search

function fzf-lovely(){
    if [ "$1" = "h" ]; then
        fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
                echo {} is a binary file ||
                (bat --style=numbers --color=always {} ||
                 highlight -O ansi -l {} ||
                 coderay {} ||
                 rougify {} ||
                 cat {}) 2> /dev/null | head -500'
    else
        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
                echo {} is a binary file ||
                (bat --style=numbers --color=always {} ||
                 highlight -O ansi -l {} ||
                 coderay {} ||
                 rougify {} ||
                 cat {}) 2> /dev/null | head -500'
    fi
}

function goo() {
    google-chrome-stable "$1" & disown
}

function sshproxy() {
    ssh -D 1080 -C -q -N "$@" &
}

function T() {
    local temp_file=$(mktemp)
    "$@" | tee "$temp_file" | batcat -l rb
}



function htp() {
  pwd=$(pwd)
  foldername=$(basename "$pwd")
  foldername_with_extension="$foldername.md"
  resultado=$("$HOME/.config/bin/bateria.sh")
  ip=$(echo "$resultado" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
  echo "Definiendo las siguientes variables:"
  echo "export htf=\"$pwd/$foldername_with_extension\""
  echo "export htcon=\"$pwd\""
  echo "export ip=\"$ip\""
}

function rmk(){
        scrub -p dod $1
        shred -zun 10 -v $1
}



function coll() {
    # Obtener el último comando del historial excluyendo números de línea y espacios iniciales
    local cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')

    # Crear un archivo temporal para guardar el comando
    local temp_file=$(mktemp)

    # Escribir el comando en el archivo temporal
    echo $cmd > "$temp_file"

    # Ejecutar el comando y usar 'tee' para duplicar la salida y 'batcat' para visualizarla
    eval $cmd | tee "$temp_file" | batcat -l rb
}




# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize 

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
source ~/.powerlevel10k/powerlevel10k.zsh-theme


    

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"
    

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${pointer}"
    

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
#para mac solo . no encontre en linux eza
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

    
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
