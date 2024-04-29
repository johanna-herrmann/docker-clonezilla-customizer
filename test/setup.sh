#!/bin/bash

chmod -R a+x dummies/*.sh

echo creating image
docker build -t test_clonezilla_customizer ../ &>/dev/null
echo -e "\n"
mkdir -p tmp/empty
chmod a+x teardown.sh
chmod a+x dummies/create_dummy.sh
