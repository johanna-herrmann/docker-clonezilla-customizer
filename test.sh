#!/bin/bash

# preparations
cd test
trap "./teardown.sh; trap '' INT EXIT" INT EXIT
chmod a+x setup.sh
chmod -R a+x dummies/*.sh
./setup.sh


# tests
echo running tests
judo ./ || exit

GREEN='\033[0;32m'
NC='\033[0m'
echo -e "\n\n${GREEN}All tests ok :-)${NC}"
