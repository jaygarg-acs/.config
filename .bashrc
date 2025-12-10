# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

alias cat='batcat'
alias ls='lsd'
alias diff='delta'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -arlt'

# FZF history search
bind -x '"\C-r": "fzf_history"'
fzf_history() {
    READLINE_LINE=$(history | fzf --height 40% --reverse --border)
    READLINE_POINT=${#READLINE_LINE}
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
alias vim="nvim"
source '/home/jgarg/.env_acs'

export tv="$ACS_GIT_DIR/turret-vision/"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# TensorRT environment variables
export LD_LIBRARY_PATH=/opt/tensorrt-10.13/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/jgarg/acs/turret-vision/guncam_cpp/executables:$LD_LIBRARY_PATH
export LIBRARY_PATH=/opt/tensorrt-10.13/lib:$LIBRARY_PATH
export PATH=/opt/tensorrt-10.13/bin:$PATH

. "$HOME/.local/bin/env"

# QT Display scaling, GTK one is in the ~/.config/gtk-3.0/settings.ini file
export QT_SCALE_FACTOR=1.5
export QT_FONT_DPI=144

# ~/.bashrc
#
# exact session existence check (no prefix matching)
_tmux_has_exact_session() {
  tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -Fxq "$1"
}

# Attach or switch (don’t nest inside tmux)
_tmux_attach_or_switch() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach -t "$1"
  fi
}

t4e() {
  local session="quad_e"

  if _tmux_has_exact_session "$session"; then
    _tmux_attach_or_switch "$session"
  else
    tmux new-session -d -s "$session" -c ~ \; \
      split-window -h -c ~ \; \
      split-window -v -c ~ \; \
      split-window -v -c ~ \; \
      select-layout -t "$session:" tiled

    _tmux_attach_or_switch "$session"
  fi
}

editor() {
    local session="editor"
    local dir="${TURRET_VIS_DIR}"
    if [[ -z "$dir" ]]; then
        echo "editor: TURRET_VIS_DIR is not set." >&2
        return 1
    fi

    if _tmux_has_exact_session "$session"; then
        _tmux_attach_or_switch "$session"
    else
        # Create a detached session in the desired directory and start nvim
        tmux new-session -d -s "$session" -c "$dir" "nvim .; exec \$SHELL"
        _tmux_attach_or_switch "$session"
    fi

}

# t4 [session] [dir] [cmd1] [cmd2] [cmd3] [cmd4]
# Top-left, top-right, bottom-left, bottom-right are filled in that order.

export PATH=/usr/local/cuda-12.8/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:$LD_LIBRARY_PATH

# Show current git branch in terminal bar
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/<\1>/'
}
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]\$ "
#acs aliases
alias ra='runall --grid'
alias rd='runall --grid --deps'
alias rw='runall --grid --wait'
alias re='t4e'
alias stv='source "${TURRET_VIS_DIR}"/.venv/bin/activate'

ec2() {
    local port_forward=""
    if [ -n "$3" ]; then
        port_forward="-L $3:localhost:$3"
    fi
    local pem="cvml-1.pem"
    if [ -n "$2" ]; then
	pem="$2"
    fi

    ssh -i $HOME/.pem/$pem $port_forward ubuntu@"$1"
}

ec2-vnc() {
    local host="$1"
    local port="$2"
    local pemfile="cvml-1.pem"
    if [ -z "$host" ] || [ -z "$port" ]; then
        echo "Usage: ec2-vnc <host> <port>"
        return 1
    fi
    ec2 "$host" "$pemfile" "$port"
}

ec2-pf() {
    local host="$1"
    local port="$2"
    local pemfile="cvml-1.pem"
    if [ -z "$host" ] || [ -z "$port" ]; then
        echo "Usage: ec2-pf <host> <port>"
        return 1
    fi
    # Check for an existing SSH session to that host
    if pgrep -af "ssh.*$host" >/dev/null; then
        echo "✅ SSH session to $host detected. Adding port forward on $port..."
    else
        echo "⚠️ No existing SSH session to $host detected."
        echo "Starting a new SSH tunnel with port forwarding..."
    fi
    ssh -i $HOME/.pem/$pemfile -NL "$2:localhost:$2" ubuntu@"$1"
}

export EDITOR="nvim"
export VISUAL="nvim"
