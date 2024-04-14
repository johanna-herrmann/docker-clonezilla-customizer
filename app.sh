#!/bin/sh

# preparations
RED='\033[0;31m'
NC='\033[0m'
if [ -d "/github/workspace" ]
then
    echo "preparing workdir"
    ln -nsf /github/workspace/$1 /opt/work 2>/dev/null
    if [ -z "$1" ] || [ ! -d "/github/workspace/$1" ]
    then
        echo "${RED}ERROR: Missing or invalid work director provided${NC}"
        exit 1
    fi
fi
workdir=/opt/work

# check workdir
if [ ! -f "$workdir/clonezilla.iso" ] || [ ! -f "$workdir/custom-ocs" ]
then
    echo "${RED}ERROR: Missing base image or custom-ocs. Correct work director provided?"
    exit 1
fi

# extracting iso file
echo "extracting iso file"
mkdir iso
mkdir extracted
xorriso -osirrox on -indev $workdir/clonezilla.iso -extract / iso >/dev/null || exit

# extracting file system
echo "extracting file system"
unsquashfs -d extracted iso/live/filesystem.squashfs >/dev/null || exit

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
echo "running generator script"
chroot extracted /root/generate.sh || exit
echo "\n\nCreated custom image successfully"
