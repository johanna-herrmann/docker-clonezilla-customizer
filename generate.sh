#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -n "running generator script  "
cd /root/work
export PATH="$PATH:/usr/sbin"
ocs-iso -g en_US.UTF-8 -k NONE -a clonezilla_customized -s -m custom-ocs &>/root/xorriso.log
rc=$?
echo ""
if [ "$rc" -ne 0 ]
then
    echo -e "${RED}ERROR: Could not create new iso file.${NC}"
    echo "output of last command follows:"
    cat /root/xorriso.log
    rm /root/xorriso.log
    exit $rc
fi
