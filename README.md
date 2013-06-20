Expanded color hints for your git prompt. 

__git_color returns an escape sequence representing a color hint.  Hints
indicate dirty state, stashes, and untracked files, and can replace the
GIT_PS1_SHOW* variables for all of these.

Hints are: (assuming standard xterm color palette)
Green: branch is up to date
Red: unstaged changes present
Yellow: staged changes present
Blue: untracked files present
Purple: untracked files + unstaged changes
Cyan: untracked files + staged changes
Underline: stashes present

__git_color is meant to be used with __git_ps1, and can be placed in the
formatting argument, or elsewhere. Example:

PS1='[\!]\u@\h:\w$(__git_ps1 " (\[$(__git_color -y)\]%s\[\033[0m\])")\$ '

Two things to note:
1) Prompt strings expect nonprinting characters to be bracketed with \[ \] (or
   %{ %} if you're using zsh). __git_color does not return these brackets. This
   allows you to use __git_color outside the prompt string.
2) Remember to reset the colors using \033[0m before the end of your string.

Usage: __git_color [STAGE_BEHAVIOR]

STAGE_BEHAVIOR controls the hint when both staged and unstaged changes are
present. By default, unstaged changes take precedence, so the hint is red
(purple if there are also untracked files). Options are:
Red - red/purple hints
Yellow - yellow/cyan hints (staged changes take precedence)
Both - yellow/cyan hints with red background

The default behavior can be changed by setting the GIT_COLOR_STAGEBEHAVIOR
variable. Supplying an argument will always override this. At present, the
argument is case-insensitive, can have any number of leading dashes, and only
looks at the first letter (so -y, --yellow, YELLOW, and Yentl will all be
interpreted as Yellow).
