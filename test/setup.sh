#!/bin/bash

echo creating image
docker build -t test_clonezilla_customizer ../ &>/dev/null
echo -e "\n"
mkdir -p tmp
chmod a+x teardown.sh
chmod a+x dummies/create_dummy.sh
