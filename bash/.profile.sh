#!/bin/bash

if [ -n "$BASH" ]; then

  source ~/.colors.sh

  if [ -z ${NOTFIRSTRUN+x} ]; then
    export initialpath="$PATH"
  fi

  if [ -z ${VIRTUAL_ENV} ]; then
    export PATH="$initialpath:/usr/games"
  fi

  __git_ps1 ()
  {
      b="$(git symbolic-ref HEAD 2>/dev/null)"
      if [ -n "$b" ]; then
          printf " %s" "${b##refs/heads/}"
      fi
  }

  alias LAST="history | tail -1 | sed 's/ *[^]]*] *//'"

  export PIPES_STR="$(sed 's: :,:g' <<< "[${PIPES[*]}]")"

  if [[ $(ls -a .) = '' ]]; then
    # CWD has been removed.
    export CWD_PS_COLOR=${PSbldred}
  else
    export CWD_PS_COLOR=${PSbldgrn}
  fi

  export PROMPT_INFO="${PSbldblu}\$(date +%H:%M:%S\ %d.%m.%y) ${PSbldred}\u@\h ${CWD_PS_COLOR}\w${PSbldylw}\$(__git_ps1) ${PSbldcyn}${DISPLAY} ${PSbldblu}\${PIPES_STR} ${PSbldpur}${VIRTUAL_ENV/~/\~}"
  export TITLE_INFO='\w'
  export PS1="\[\033]0;${TITLE_INFO}\007\]\n${PROMPT_INFO}\n${PSbldwht}\$ ${PStxtrst}"

  export EDITOR=vim

  export GOPATH="${HOME}/go"

  function IsScreen {
    if [ "$TERM" = 'screen' ]; then
      return 0
    elif [ "$TERM" = 'screen-256color' ]; then
      return 0
    else
      return 1
    fi
  }

  function I {
    [ $# -ge 2 ] && color=${2} || color=${bakred}
    len="`bc <<< $(wc -c <<< \"$1\")-1`"
    cols="`tput cols`"
    echo -en ${color}
    echo -n "$1"
    printf ' %.0s' `seq $(bc <<< ${cols}-${len}-1)`
    echo -en ${txtrst}
    echo
  }

  function Forcefully {
    while true; do $*; done
  }

  function ProgressBar {
    [ $# -ge 2 ] || Exit ${FUNCNAME}:${LINENO}

    maximum=${1}
    cmd=${2}

    val=0
    while [ `bc -l <<< "${val}<${maximum}"` -eq 1 ]; do
      cols=`tput cols`

      val=`bash -c "${cmd}"`
      frac=`bc -l <<< "${val}/${maximum}"`
      proc=`bc -l <<< "${frac}*100"`

      echo -en "${cursav}|"
      len=`bc <<< $(bc -l <<< "(${cols}-10)*${frac}")'/1'`
      rest=`bc <<< "${cols}-10-${len}"`
      echo -en "${bldblu}"
      if [ ${len} -ge 1 ]; then printf '=%.0s' `seq ${len}`; fi
      echo -en "${txtred}"
      if [ ${rest} -ge 1 ]; then printf -- '-%.0s' `seq ${rest}`; fi
      echo -en "${txtrst}"
      echo -en '| '`sed 's/^[^.]*\([^.]\{3\}[.].\{2\}\).*$/\1/' <<< '__'${proc}'.00'`"%${curres}"

      sleep .2
    done

    echo
  }

  function DuProgressBar {
    [ $# -ge 2 ] || Exit ${FUNCNAME}:${LINENO}

    max=`du ${1} | tail -1 | cut -f1`
    ProgressBar "${max}" 'du '"${2}"' | tail -1 | cut -f1'
  }

  function git-metric {
    [ $# -ge 2 ] || Exit ${FUNCNAME}:${LINENO}
    git log --numstat --pretty="%H" ${1}..${2} | \
      awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d, +%d, -%d\n", plus+minus, plus, minus)}'
  }

  alias DING="echo -en '\a'"

  export HISTSIZE=
  export HISTFILESIZE=
  export HISTFILE=~/.bash_eternal_history
  export HISTCONTROL=ignorespace:ignoredups

  history() {
    _bash_history_sync
    builtin history "$@"
  }

  _bash_history_sync() {
    builtin history -a         #1
    HISTFILESIZE=$HISTSIZE     #2
    builtin history -c         #3
    builtin history -r         #4
  }

  function HostnameHash {
    let hash=$(printf '%d' 0x`hostname | md5sum | head -c 8`)' % 16'

    if   [ $hash -le 0 ]; then let ret=0
    elif [ $hash -le 8 ]; then let ret=${hash}' + 28'
    else                       let ret=${hash}' + 81'
    fi

    echo -n $ret
  }

  function SetScreenWindowTitle {
    if `IsScreen`; then
      mytitle="$@"
      echo -e '\033k'"$mytitle"'\033\\'
    fi
  }

  export shortLast=`(LAST; echo '______________________________') | head -c 10`

  PROMPT_COMMAND="PIPES=(\"\${PIPESTATUS[@]}\"); SetScreenWindowTitle .; _bash_history_sync; source ~/.profile.sh"

  ## reedit a history substitution line if it failed
  shopt -s histreedit
  ## edit a recalled history line before executing
  shopt -s histverify

  export TZ=/usr/share/zoneinfo/Poland


  function varalias {
    if [ $# -ne 2 ]; then
      echo >&2 "varalias $*: failed"
      return 1
    fi
    k="$1"
    v="$2"
    export "$k"="$v"
    alias "$k"="$v"
  }


  varalias V 'vim'
  varalias VR 'vim -R'

  varalias git_list 'git diff-tree -r HEAD | awk "{print \$6}"'
  alias git-list='git_list'

  varalias git_list_conflicted 'git diff --name-only --diff-filter=U'
  alias git-list-conflicted='git_list_conflicted'

  varalias _q 'sl'
  alias :q='_q'
  varalias _e 'vim'
  alias :e="_e"

  varalias much 'git'
  varalias such 'git'
  varalias wow "$git_list && git status && echo && git log -2"


  varalias ga 'git add'

  varalias gb 'git branch'
  varalias gba 'git branch -a'

  varalias GB "git reflog | grep checkout | awk '{print \$NF}' | tac | awk '!x[\$0]++'"

  varalias gB 'git blame'

  varalias gc 'git checkout'
  varalias gcb 'git checkout -b'
  varalias gcH 'git checkout HEAD^ --'

  varalias gC 'git commit'
  varalias gCm 'git commit -m'
  varalias gCa 'git commit -a'
  varalias gCam 'git commit -a -m'
  varalias GC 'git commit -a -m . --allow-empty'
  varalias gCn 'git commit --no-edit'
  varalias gCan 'git commit -a --no-edit'
  varalias gCA 'git commit --amend'
  varalias gCAm 'git commit --amend -m'
  varalias gCAam 'git commit --amend -a -m'
  varalias gCAn 'git commit --amend --no-edit'
  varalias gCAan 'git commit --amend -a --no-edit'
  varalias gCe 'git commit --allow-empty'
  varalias gCem 'git commit --allow-empty -m'
  varalias gCea 'git commit --allow-empty -a'
  varalias gCeam 'git commit --allow-empty -a -m'
  varalias gCen 'git commit --allow-empty --no-edit'
  varalias gCean 'git commit --allow-empty -a --no-edit'
  varalias gCeA 'git commit --allow-empty --amend'
  varalias gCeAm 'git commit --allow-empty --amend -m'
  varalias gCeAam 'git commit --allow-empty --amend -a -m'
  varalias gCeAn 'git commit --allow-empty --amend --no-edit'
  varalias gCeAan 'git commit --allow-empty --amend -a --no-edit'

  varalias gd 'git diff'
  varalias gdH 'git diff HEAD^'
  varalias gdA 'git diff -U999999'
  varalias gdHA 'git diff HEAD^ -U999999'

  varalias gf 'git fetch'
  varalias gfa 'git fetch --all'

  varalias gg 'git grep'

  varalias gl 'git log'
  varalias glo 'git log --format=oneline'

  varalias gm 'git merge'
  varalias gmf 'git merge --ff-only'

  varalias gp 'git pull'
  varalias gpr 'git pull --rebase'

  varalias gP 'git push'
  varalias gPom 'git push origin master'

  varalias gr 'git rebase'

  varalias gR 'git reflog'

  varalias gra 'git rebase --abort'

  varalias grc 'git rebase --continue'
  varalias gri 'git rebase --interactive'
  varalias grs 'git rebase --skip'

  varalias gs 'git status'


  varalias l 'ls'
  varalias la 'ls -alh'
  varalias ll 'ls -alh'

  varalias errcho '>&2 echo'

  varalias xclipc 'xclip -selection clipboard'

  varalias fucking 'sudo'
  varalias wtf 'man'

  function scr {
    [ $# -gt 0 ] && sessionname=$1 || sessionname=a
    screen -xS "$sessionname" || screen -S "$sessionname"
  }
  varalias S 'scr'

  varalias C 'reset'

  varalias F 'find'

  varalias G 'grep'

  varalias k91 'kill -9 %1'
  varalias kk91 'kill -9 %1'
  varalias gk 'pkill -g $$'

  varalias hl '~/highlighter.py'
  varalias hlall "~/highlighter.py '.*'"

  varalias teerr 'tee >( cat >&2 )'

  function venvactivate {
    envname=${1-venv}
    source "${envname}/bin/activate"
  }
  varalias va 'venvactivate'
  varalias vd 'deactivate'

  varalias DN '/dev/null'

  function mkdircd {
    mkdir "$@"
    cd "$@"
  }

  varalias cdpwd 'cd $(pwd)'

  varalias t 'time'

  varalias nobuf 'stdbuf -i0 -o0 -e0'

  varalias PS 'ps -o pid,ppid,pgid,comm'

  function escape {
    while read; do
      printf '%q\n' "${REPLY}"
    done
  }

  varalias N 'nice -n 19'

  function get_process_tree {
    ROOT_PID=${1}
    if [[ -z "${ROOT_PID}" ]]; then
      return 1
    fi

    for PID in "${@}"; do
      /bin/echo "${PID}"
      get_process_tree $(/usr/bin/pgrep -P "${PID}")
    done
  }

  varalias cdt 'cd `mktemp -d`'

  varalias pk '/usr/bin/pkill -s 0 --'

  function process_counts {
    ps aux | awk '{print $11}' | sort | uniq -c | sort -n
  }

  ###

  source ~/.local-profile.sh

  export NOTFIRSTRUN=true

fi
