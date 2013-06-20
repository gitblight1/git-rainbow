# git-color.sh
#
# create an escape sequence to colorize __git_ps1
# __git_ps1 allows color hints as of version 1.8, but I think this is better.
# clean repo is green
# red means unstaged changes
# yellow means staged changes
# blue means untracked files
# purple or cyan means untracked files + changes
# underline indicates stashes present
#
# optional argument to set behavior for staged + unstaged changes:
# (r)ed - unstaged takes precedence (default)
# (y)ellow - staged takes precedence
# (b)oth - red background with yellow text

# argument is case insensitive, can have any number of leading dashes, and only
# tracks the first letter; i.e, both, -B --bOtH, ---BELCH are all the same.
# Can also set this using GIT_COLOR_STAGEBEHAVIOR. The argument will override
# the environment variable; e.g., "__git_color red" will return red
# text if both kinds of changes are present, even if GIT_COLOR_STAGEBEHAVIOR
# is set to "yellow"


__git_color()
{
  local c1=""
  local -i c2=30
  local stage_behavior=${1:-$GIT_COLOR_STAGEBEHAVIOR}
  stage_behavior=${stage_behavior##*-} # strip any leading dashes
  if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]
  then
	  printf "" # blank string
	  exit 0
  fi
  c1='1;'
  # check for stashes
  git rev-parse --verify refs/stash >/dev/null 2>&1 && c1='4;'

  # check for unstaged changes
  git diff --no-ext-diff --quiet --exit-code 2>/dev/null || c2=31
  # check for staged changes
  if ! $(git rev-parse --quiet --verify HEAD >/dev/null && git diff-index --cached --quiet HEAD --)
  then
	  if [ 31 -eq $c2 ]; then
		  # staged and unstaged exist, how to handle
		  case ${stage_behavior:0:1} in
			  [Bb]) # indicate both
				  c1="41m\033[${c1}" # make background red
				  c2=33 # and foreground yellow
				  ;;
			  [Yy]) # staged changes take precedence
				  c2=33
				  ;;
			  *) # default case; unstaged changes take precedence
				  ;;
		  esac
	  else
		  c2=33
	  fi
  fi
  
  # check for untracked files
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
	  c2+=4
  fi
  
  [ 30 -eq $c2 ] && c2=32 # clean repo, 32 = green
  [ 37 -eq $c2 ] && c2=36 # untracked + staged changes = cyan
  local color="\033[${c1}${c2}m"
  printf "%b" "$color" # %b is for escape sequence
  exit 0
}

