# FreeAgent puts the powerline style in zsh !

SEGMENT=$'\ue0b0'

eval COLOR_RESET="%{$terminfo[sgr0]%}"

POWERLINE_COLOR_BG_GRAY=%K{240}
POWERLINE_COLOR_BG_LIGHT_GRAY=%K{240}
POWERLINE_COLOR_BG_WHITE=%K{255}

POWERLINE_COLOR_FG_GRAY=%F{240}
POWERLINE_COLOR_FG_LIGHT_GRAY=%F{240}
POWERLINE_COLOR_FG_WHITE=%F{255}

GIT_DIRTY_COLOR=%F{133}
GIT_CLEAN_COLOR=%F{118}
GIT_AHEAD_COLOR=%F{011}
GIT_PROMPT_INFO=%F{012}

ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="$GIT_PROMPT_INFO"
ZSH_THEME_GIT_PROMPT_DIRTY=" $GIT_DIRTY_COLOR✘ "
ZSH_THEME_GIT_PROMPT_CLEAN=" $GIT_CLEAN_COLOR✔ "
ZSH_THEME_GIT_PROMPT_AHEAD=" $GIT_AHEAD_COLOR⚡ "

ZSH_THEME_GIT_PROMPT_ADDED="%F{082}✚%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{166}✹%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{160}✖%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{220]➜%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{082]═%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{190]✭%f"

# Construct the git prompt
function git_prompt {
        gp=" $(git_prompt_short_sha)$(git_prompt_info)$(git_prompt_ahead)"
        if [ "x$gp" != "x" ]; then
                echo "${GIT_PRE}${gp}${GIT_POST}"
        else
                echo ""
        fi
}
local git_branch='$(git_prompt)'

PROMPT="
%k%f%F{green}%K{010} %~ %F{010}%K{blue}$SEGMENT%k%f%F{white}%K{blue} "${git_branch}" %k%f%F{blue}"$SEGMENT"%f 
$POWERLINE_COLOR_BG_WHITE $POWERLINE_COLOR_FG_GRAY%D{%D %H:%M:%S} %f%k"$POWERLINE_COLOR_FG_WHITE$SEGMENT"%f%k "
