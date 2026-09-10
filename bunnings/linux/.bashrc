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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
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

# >>> conda initialize >>>
# Disabled: this machine uses uv for Python environment management, not conda.
# conda init auto-activates base and puts /anaconda/bin on PATH, which shadows
# uv-managed .venv/bin/python. Commented out rather than deleted so it can be
# re-enabled if needed. See also: auto-activate uv venv block below.
#
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/anaconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/anaconda/etc/profile.d/conda.sh" ]; then
#         . "/anaconda/etc/profile.d/conda.sh"
#     else
#         export PATH="/anaconda/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# Machine-specific overrides (not tracked in repo)
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# --- Auto-activate uv venv ---------------------------------------------------
# Why: When opening a terminal in a uv-managed Python project, bare `python`,
# `pytest`, `ruff`, `mypy` should resolve to the project's .venv — not system
# Python or conda.
#
# How it works:
#   1. Walk up from $PWD looking for pyproject.toml (marks a Python project root)
#   2. If that directory also has .venv/bin/python (uv creates this), prepend
#      .venv/bin to PATH — same effect as `source .venv/bin/activate` but lighter
#   3. Set VIRTUAL_ENV so tools that check for it (pip, poetry, etc.) behave
#   4. No-op if already activated or if no uv project is found
#
# Limitation: this runs once at shell startup, not on every `cd`. If you navigate
# to a different project within the same shell, bare `python` still points at the
# original project's venv. For cross-project safety (especially AI agents that
# navigate between projects), use `uv run python` which resolves per-invocation.
#
# Safe because: only prepends to PATH (doesn't clobber), only activates for the
# current shell, and only when a real .venv exists alongside pyproject.toml.
_auto_activate_uv_venv() {
    # Skip if a valid virtualenv is already active
    [ -n "${VIRTUAL_ENV:-}" ] && return

    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/pyproject.toml" ] && [ -x "$dir/.venv/bin/python" ]; then
            export VIRTUAL_ENV="$dir/.venv"
            export PATH="$dir/.venv/bin:$PATH"
            return
        fi
        dir="$(dirname "$dir")"
    done
}
_auto_activate_uv_venv
# --- End auto-activate --------------------------------------------------------


# in yazi drop to cwd when exiting
# press y to start yazi, and q to quit, Q to quit to original dir
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# cortex CLI: bypass proxy (Azure ML injects proxy; PrivateLink needs direct access)
alias cortex='NO_PROXY="snowflakecomputing.com${NO_PROXY:+,${NO_PROXY}}" no_proxy="snowflakecomputing.com${no_proxy:+,${no_proxy}}" ~/.local/bin/cortex'

# Global proxy bypass for internal-only endpoints (Azure ML compute instances inject
# http_proxy/https_proxy for public internet access, but internal Private Link / VNet-only
# hosts like Snowflake and our internal MLflow servers must NOT go through that proxy, or
# connections fail with "Tunnel connection failed: 503 Service Unavailable" / squid
# ERR_DNS_FAIL. Added 2026-09-10 while locally testing ao-consumer-flybuys-rfm-segmentation
# (GHA/uv migration) against Snowflake DE + mlflow-exp. Unlike the `cortex` alias above,
# this is applied shell-wide since many different tools/scripts hit these hosts, not just one.
export no_proxy="${no_proxy:+$no_proxy,}snowflakecomputing.com,.dna.bunnings.com.au"
export NO_PROXY="$no_proxy"
