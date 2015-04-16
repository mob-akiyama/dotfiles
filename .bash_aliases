#!/bin/sh

# disable history in this file
set +o history

export PATH=$PATH:$HOME/bin
export EDITOR=/usr/bin/vim
export PAGER='/usr/bin/lv -c'

HISTSIZE=100000
HISTTIMEFORMAT='%Y-%m-%d %T : '
HISTIGNORE="fg*:bg*:history*"
HISTCONTROL=ignoreboth

RED="0;31"
START_COLOR="\[\e[${RED}m\]"
END_COLOR="\[\e[0m\]"
PYTHONDONTWRITEBYTECODE=1
GIT_PS1_SHOWDIRTYSTATE=true
PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]'\'\(^_^\)/\[\e[0m\]; else echo \[\e[31m\]/\(^o^\)'\'\[\e[0m\]; fi\`:\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]\$(__git_ps1)\[\033[00m\]\\$ "

# for mac
stty erase ^?
# disable Ctrl + s
stty stop undef

#alias vim=/usr/local/vim74/bin/vim
alias head5='head -50'
alias tail5='tail -50'
alias python2='python2 -B'
alias python3='python3 -B'
alias python="python -B"
alias jq='jq -C'
alias lv='lv -c'

for project in next drz quu mpz cmn dsh bill nxt jpr kdz kpr kmp; do
  alias aws_${project}="aws --profile ${project}"
  alias aws_ec2_${project}="aws --profile ${project} ec2 describe-instances | jq '.Reservations[].Instances[] | {name: .Tags[].Value, type: .InstanceType, public_ip: .PublicIpAddress}'"
  alias aws_rds_${project}="aws --profile ${project} rds describe-db-instances | jq '.DBInstances[] | {name: .DBInstanceIdentifier, type: .DBInstanceClass, storage: .AllocatedStorage, storagetype: .StorageType}'"
  alias aws_cache_${project}="aws --profile ${project} elasticache describe-cache-clusters | jq '.CacheClusters[] | {name: .CacheClusterId, type: .CacheNodeType}'"
  complete -C aws_completer aws_${project}
done

gitlog_one() {
  if [ -n "$1" ]; then
    git log --oneline -n $1
  else
    git log --oneline
  fi
}

dirhist=()
dirhistmax=40
custom_cd() {
  if  [ -n "$1" ]; then
    if [ ${#dirhist[*]} -ge $dirhistmax ]; then
      newhist=()
      for ((i=1; i<=$dirhistmax; i++)); do
        newhist+=("${dirhist[$i]}")
      done
      dirhist=("${newhist[@]}")
    fi

    dirhist+=("$1")
  fi

  cd $1
}

cdm() {
  if [ -z "$1" ]; then
    for ((i=0; i<${#dirhist[*]}; i++)); do
      echo $i: ${dirhist[$i]}
    done
  elif [[ "$1" =~ [a-zA-Z] ]]; then
    local prev_index=$((${#dirhist[*]}-2))
    cd ${dirhist[$prev_index]}
  else
    to="${dirhist[$1]}"
    if [ -n "$to" ]; then
      cd ${dirhist[$1]}
    else
      echo $1 not memoried
    fi
  fi
}

alias cd='custom_cd'

for f in ~/.bash_aliases.d/*; do
    . $f
done

# enable history
set -o history