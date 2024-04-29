#!/bin/sh

# preparations
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
workdir=/opt/work
if [ -d "/github/workspace" ]
then
    echo "preparing workdir"
    if [ -z "$WORK_DIR" ] || [ ! -d "/github/workspace/$WORK_DIR" ]
    then
        echo -e "${RED}ERROR: Missing or invalid work directory provided${NC}"
        exit 1
    fi
    workdir=/github/workspace/$WORK_DIR
fi

# check workdir
if [ ! -f "$workdir/clonezilla.iso" ] || [ ! -f "$workdir/custom-ocs" ]
then
    echo -e "${RED}ERROR: Missing base image or custom-ocs.${NC}"
    echo "Correct work directory provided?"
    exit 1
fi

# extracting iso file
echo -n "extracting iso file  "
mkdir iso
xorriso -osirrox on -indev $workdir/clonezilla.iso -extract / iso &>out.log || \
   { rc=$?; echo -e "\n${RED} ERROR: Could not extract iso file.${NC} See following output:"; cat out.log; exit $rc; }
echo ""
if [ ! -f "iso/live/filesystem.squashfs" ]
then
    echo -e "${RED}ERROR: Invalid base image iso file. Missing live/filesystem.squashfs${NC}"
    exit 2
fi

# extracting filesystem
echo -n "extracting filesystem  "
mkdir extracted
unsquashfs -d extracted iso/live/filesystem.squashfs &>out.log || \
   { rc=$?; echo -e "\n${RED} ERROR: Could not extract filesystem.${NC} See following output:"; cat out.log; exit $rc; }

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
chroot extracted/ /root/generate.sh || exit

echo -e "\n${GREEN}Created custom image successfully${NC}"
