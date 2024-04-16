#!/bin/sh

# preparations
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
if [ -d "/github/workspace" ]
then
    echo "preparing workdir"
    if [ -z "$1" ] || [ ! -d "/github/workspace/$1" ]
    then
        echo -e "${RED}ERROR: Missing or invalid work director provided${NC}"
        exit 1
    fi
    ln -nsf /github/workspace/$1 /opt/work 2>/dev/null
fi
workdir=/opt/work

# check workdir
if [ ! -f "$workdir/clonezilla.iso" ] || [ ! -f "$workdir/custom-ocs" ]
then
    echo -e "${RED}ERROR: Missing base image or custom-ocs.${NC}"
    echo "Correct work director provided?"
    exit 1
fi

# extracting iso file
echo -n "extracting iso file  "
mkdir iso
xorriso -osirrox on -indev $workdir/clonezilla.iso -extract / iso &>out.log || \
   { echo -e "\n${RED} ERROR: Could not extract iso file.${NC} See following output:"; cat out.log; exit; }
echo ""
if [ ! -f "iso/live/filesystem.squashfs" ]
then
    echo -e "${RED}ERROR: Invalid base image iso file. Missing live/filesystem.squashfs${NC}"
    exit 2
fi

# extracting file system
echo -n "extracting file system  "
mkdir extracted
unsquashfs -d extracted iso/live/filesystem.squashfs &>out.log || \
   { echo -e "\n${RED} ERROR: Could not extract filesystem.${NC} See following output:"; cat out.log; exit; }

# bind-mounting iso, extra files and workdir
echo "bind-mounting iso, extra files and workdir"
mkdir -p extracted/run/live/medium
mount --bind iso extracted/run/live/medium
if [ -d "$workdir/extra" ]
then
    mkdir -p extracted/run/live/medium/live/extra
    mount --bind "$workdir/extra" extracted/run/live/medium/live/extra
fi
mkdir -p extracted/root/work
mount --bind "$workdir" extracted/root/work

# adding generator script
echo "adding generator script"
cp generate.sh extracted/root/
chmod a+x extracted/root/generate.sh

# bind-mounting dev and proc
echo "bind-mounting dev and proc"
mount --bind /dev extracted/dev || exit
mount --bind /proc extracted/proc || exit

# generate
chroot extracted /root/generate.sh || exit

echo -e "\n${GREEN}Created custom image successfully${NC}"
