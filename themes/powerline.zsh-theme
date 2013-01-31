# FreeAgent puts the powerline style in zsh !
autoload -U colors zsh/terminfo
colors
setopt prompt_subst

function zle-keymap-select {
	# if the terminal is n-lines, print n-1 lines to avoid overwriting buffer
	printf "\n\n"
	zle reset-prompt
}

zle -N zle-keymap-select

SEGMENT=$'\ue0b0'

local reset white_fg gray_fg magenta_fg red_fg yellow_fg blue_fg green_fg white_bg blue_bg magenta_bg green_bg red_bg

reset="%{$terminfo[sgr0]%}"
white_fg="%{$fg[white]%}"
gray_fg="%{$fg_bold[black]%}"
magenta_fg="%{$fg[magenta]%}"
red_fg="%{$fg[red]%}"
yellow_fg="%{$fg_bold[yellow]%}"
blue_fg="%{$fg[blue]%}"
green_fg="%{$fg[green]%}"
white_bg="%{$bg[white]%}"
blue_bg="%{$bg[blue]%}"
magenta_bg="%{$bg[magenta]%}"
green_bg="%{$bg[green]%}"
red_bg="%{$bg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="$GIT_PROMPT_INFO"
ZSH_THEME_GIT_PROMPT_DIRTY="${red_fg} ✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="${green_fg} ✔ "
ZSH_THEME_GIT_PROMPT_AHEAD="${yellow_fg}⚡ "

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='%U%m%u' #SSH
else
  eval PR_HOST='%m' # no SSH
fi

local -a clock

clock+=( ${reset} )
clock+=( ${blue_bg} )
clock+=( ${white_fg} )
clock+=( " %D{%D %H:%M:%S} " )
clock+=( ${reset} )

local clock_width
clock_width=${(S)clock//\%\{*\%\}}
clock_width=${#${(%)clock_width}}

local -a git

function git_prompt {
	if [ "x$(git_prompt_short_sha)" != "x" ]; then
		gp="$(git_prompt_short_sha)$(git_prompt_info)$(git_prompt_ahead)"
	else
		gp=""
	fi
	if [[ "x$gp" != "x" ]]; then
		echo " ${GIT_PRE}${gp}${GIT_POST} ${white_fg}${blue_bg}$SEGMENT"
	else
		echo ""
	fi
}

function update_top_padding {
	local git_width
	git_width=${(S)$(git_prompt)//\%\{*\%\}}
	git_width=${#${(%)git_width}}
	if [[ $git_width > 0 ]]; then
		git_width=$(( ${git_width} + 2 ))
	fi
	local termwidth
	# need to test for portability
	(( termwidth = ${COLUMNS} + 4 ))

	local topwidth=$(( ${git_width} + ${clock_width} ))

	local toppadding=$(( ${termwidth} - ${topwidth} ))

	local topfiller
	for i in {1..$toppadding}; do
		topfiller=$topfiller" "
	done
	echo ${reset}${blue_fg}${blue_bg}$topfiller
}

function update_middle_padding {
	local pwd_width=${#${(%):-%d}}
	local termwidth
	(( termwidth = ${COLUMNS} - 1 ))
	local middlepadding=$(( ${termwidth} - ${pwd_width} ))
	local middlefiller
	for i in {1..$middlepadding}; do
		middlefiller=$middlefiller" "
	done
	echo ${reset}${green_bg}${green_bg}$middlefiller
}

function update_zsh_mode() {
	if [[ $KEYMAP == vicmd ]]; then
		echo "${red_bg}${white_fg} NORMAL ${red_fg}${magenta_bg}"
	else
		echo "${white_bg}${red_fg} INSERT ${white_fg}${magenta_bg}"
	fi
}

local -a git
git+=( ${reset} )
git+=( ${gray_fg} )
git+=( ${white_bg} )
git+=( '$(git_prompt)' )

local gitfiller='$(update_top_padding)'

local top
top=${(j::)git}${gitfiller}${(j::)clock}

local -a pwd
pwd+=( ${reset} )
pwd+=( ${yellow_fg} )
pwd+=( ${green_bg} )
pwd+=( " " )
pwd+=( %U%d%u )

local pwdfiller='$(update_middle_padding)'

local middle
middle=${(j::)pwd}${pwdfiller}

local -a mode
mode+=( ${reset} )
mode+=( '$(update_zsh_mode)' )
mode+=( $SEGMENT )

local -a bottom
bottom+=( ${(j::)mode} )
bottom+=( ${reset} )
bottom+=( ${white_fg} )
bottom+=( ${magenta_bg} )
bottom+=( " " )
bottom+=( %n@${PR_HOST} )
bottom+=( " " )
buttom+=( ${reset} )
bottom+=( ${magenta_fg} )
bottom+=( %k$SEGMENT )
bottom+=( ${reset} )

PROMPT="
${top}
${middle}
${(j::)bottom} "

# nice for updating time, but makes cursor jump
#schedprompt() {
#  emulate -L zsh
#  zmodload -i zsh/sched

  # Remove existing event, so that multiple calls to
  # "schedprompt" work OK.  (You could put one in precmd to push
  # the timer 30 seconds into the future, for example.)
#  integer i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
#  (( i )) && sched -$i

  # if the terminal is n-lines, print n-1 lines to avoid overwriting buffer
#  printf "\n\n"

  # Test that zle is running before calling the widget (recommended
  # to avoid error messages).
  # Otherwise it updates on entry to zle, so there's no loss.
#  zle && zle reset-prompt

  # This ensures we're not too far off the start of the minute
#  sched +1 schedprompt
#}

#schedprompt
