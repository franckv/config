HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/franck/.zshrc'

autoload -Uz compinit
compinit

#bindkey "^R" history-search-backward
bindkey '^R' history-incremental-search-backward
bindkey	'\e[5~'   vi-beginning-of-line
bindkey	'\e[6~'   vi-end-of-line


export EDITOR="vim"
export PAGER="most -S"
export LESSCHARSET=utf-8
export LANG="fr_FR.utf8"
export LANGUAGE="fr_FR.utf8"
export LC_ALL="fr_FR.utf8"

export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';

alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias la='ls --color=auto -A'
alias l='ls --color=auto -CF'
alias :q='exit'
alias vi='vim'
alias ncmpc='ncmpc -c'
alias grep='grep -i'

local red="%{[1;32m%}"
local lightblue="%{[0;31m%}"
local white="%{[0m%}"

export PROMPT="${lightblue}[${red}%n@%m${lightblue}][${red}%~${lightblue}]${white}
%(!.#.$) "
export PROMPT2="> "
export RPROMPT="${lightblue}[${red}%*${lightblue}]${white}"



# colorized pacman output with pacs alias:
alias pacs="pacsearch"
pacsearch () {
echo -e "$(pacman -Ss $@ | sed \
	-e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
	-e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
	-e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
	-e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}

alias -s pdf=evince
