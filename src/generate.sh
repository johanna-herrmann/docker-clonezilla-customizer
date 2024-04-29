#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -n "running generator script  "
cd /root/work
export PATH="$PATH:/usr/sbin"
ocs-iso -g en_US.UTF-8 -k NONE -a clonezilla_customized -s -m custom-ocs &>/root/out.log || \
   { rc=$?; echo -e "\n${RED} ERROR: Could not generate custom iso file.${NC} See following output:"; cat /root/out.log; exit $rc; }
