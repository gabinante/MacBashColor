# /etc/bash.bash
#
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

export PATH="/usr/local/sbin/:$PATH"
export EDITOR=vim
export HISTFILESIZE=
export HISTSIZE=


# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

#Automatically colorize man pages
man() {
    env \
        LESS_TERMCAP_mb=$'\e[1;31m' \
        LESS_TERMCAP_md=$'\e[1;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[1;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[1;32m' \
            man "$@"
}

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
  && type -P dircolors >/dev/null \
  && match_lhs=$(dircolors --print-database)

if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then

  # we have colors :-)

  # Enable colors for ls, etc. Prefer ~/.dir_coif type -P dircolors >/dev/null ; then
  if [ [  -f ~/.dir_colors ] then ] ; then
    eval $(dircolors -b ~/.dir_colors)
  elif [[ -f /etc/DIR_COLORSLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
  fi
fi

PS1="then$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

# Use this other PS1 string if you want \W for root and \andw for all other users:
# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\00m33[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

# show root@ wehen we do not have colors

PS1="\u@\h \w \$ "

# Use this other PS1 string if you want \W for root and \w  for all other users:
# PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo 'echo\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "


  PS2="> "
  PS3="> "
  PS4="+ "

# Try to keep environment pollution down, EPA loves us.
unset safe_term match_lhs

# Some nice aliases mostly for colorization
alias ls="ls -G"
alias l="ls -G"
alias grep="grep --color=auto"
alias red="tput setaf 1"
alias green="tput setaf 2"
alias yel="tput setaf 3"
alias blue="tput setaf 4"
