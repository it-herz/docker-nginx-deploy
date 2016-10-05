#!/bin/bash

IFS=';;;;'
envs=(`cat /proc/1/environ | xargs -0 -n 1 echo ';;;;'`)
unset IFS

for _curVar in "${envs[@]}"
do
  value=`echo "$_curVar" | awk -F = '{print $2}'`
  name=`echo "$_curVar" | awk -F = '{print $1}' | xargs`
  if [ "$name" == "" ]
  then
    continue
  fi

  if [ "$name" == "GITHOST" ]
  then
    GITHOST="$value"
  fi
  if [ "$name" == "DEVUSER" ]
  then
    DEVUSER="$value"
  fi
  if [ "$name" == "TIMEZONE" ]
  then
    sed -i -e "s~;date.timezone\s*=.*~date.timezone=$value~g" /usr/local/etc/php/php.ini
  fi
done

echo "$DEVUSER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/$DEVUSER
adduser -h /var/www/html -G nginx -s /bin/bash -D $DEVUSER
echo "$DEVUSER:$DEVPASS" | chpasswd

mkdir /var/www/html/.ssh
cat /key.pub >> /var/www/html/.ssh/authorized_keys
chmod 600 /var/www/html/.ssh/authorized_keys

