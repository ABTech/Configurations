#!/bin/bash
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
IFS=$'\n'
for line in `pts mem abtech:staff -noauth | grep -v @`; do
  len=${#line}
  if [[ $len -lt 11 ]]
  then
    andrewid=`echo $line | cut -c3-11`
    passwdid=`echo $andrewid":"`
    if [[ ! -n `cat /etc/passwd | grep $passwdid` ]]
      then echo $andrewid
        shell=`ldapsearch -x -h ldap.andrew.cmu.edu -b uid=$andrewid,ou=account,dc=andrew,dc=cmu,dc=edu -LLL shell | grep shell | cut -c8-`
        homeDir=`ldapsearch -x -h ldap.andrew.cmu.edu -b uid=$andrewid,ou=account,dc=andrew,dc=cmu,dc=edu -LLL homeDir | grep homeDir | cut -c10-`
        unixUid=`ldapsearch -x -h ldap.andrew.cmu.edu -b uid=$andrewid,ou=account,dc=andrew,dc=cmu,dc=edu -LLL unixUid | grep unixUid | cut -c10-`

        useradd -s $shell -d $homeDir -u $unixUid -g 1010 $andrewid 
    fi
  fi
done

