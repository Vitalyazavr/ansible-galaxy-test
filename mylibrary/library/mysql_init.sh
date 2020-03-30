#!/bin/bash
source $1
datadir=${datadir:-/var/lib/mysql}
user=${user:-mysql}
insecure=${insecure:-true}
deffile=${deffile:-/etc/my.cnf}
if [[ -d $datadir ]] && systemctl is-active mysqld >/dev/null 2>&1
then
  # echo "MySQL already initialized"
  echo { \"changed\": false }
  exit 0
else
  if [[ $insecure == "true" ]]
  then
    mysqld --initialize-insecure --user=$user
    # echo "MySQL initialized"
    echo { \"changed\": true }
    exit 0
  else
    mysqld --initialize --user=$user
    # echo "MySQL initialized"
    echo { \"changed\": true }
    exit 0
  fi
fi
