#!/bin/bash
source $1
datadir=${datadir:-/var/lib/mysql}
user=${user:-mysql}
insecure=${insecure:-false}
deffile=${deffile:-/etc/my.cnf}
if test -d $datadir && test "systemctl status mysqld | grep dead"
then
  echo "MySQL already initialized"
  echo { \"changed\": false }
  exit 0
else
  if [[ $insecure == true ]]
  then
    mysqld --initialize-insecure --user=mysql --datadir=$datadir --defaults-file=$deffile
    echo "MySQL initialized"
    echo { \"changed\": true }
    exit 0
  else
    mysqld --initialize --user=mysql --datadir=$datadir --defaults-file=$deffile
    echo "MySQL initialized"
    echo { \"changed\": true }
    exit 0
  fi
fi

# cat << EOF
# {"changed": true, "msg": "${msg}"}
# EOF
