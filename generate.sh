#!/bin/bash

cd /root/work
export PATH="$PATH:/usr/sbin"
ocs-iso -g en_US.UTF-8 -k NONE -a clonezilla_customized -s -m custom-ocs >/dev/null
