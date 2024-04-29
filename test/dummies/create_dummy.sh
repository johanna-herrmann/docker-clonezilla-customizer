#!/bin/sh
EXCLAMATION=!
echo "#${EXCLAMATION}/bin/sh">tmp/root/app.sh
cat $1>>tmp/root/app.sh
cat ../src/app.sh | grep -v "/bin/sh" >>tmp/root/app.sh
