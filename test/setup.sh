#!/bin/bash

echo creating image
docker build -t test_clonezilla_customizer ../ &>/dev/null
echo -e "\n"
mkdir workdir
