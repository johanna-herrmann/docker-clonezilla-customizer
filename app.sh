#!/bin/sh

# preparations
spacer="\n\n\n"
if [ -d "/github/workspace" ]
then
    echo "preparing workdir"
    ln -nsf /github/workspace/$1 /opt/work 2>/dev/null
fi
workdir=/opt/work

# extracting iso file
echo "extracting iso file"
mkdir iso
mkdir extracted
xorriso -osirrox on -indev $workdir/clonezilla.iso -extract / iso >/dev/null

# extracting file system
echo "extracting file system"
unsquashfs -d extracted iso/live/filesystem.squashfs >/dev/null

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
mount --bind /dev extracted/dev
mount --bind /proc extracted/proc

# generate
echo "running generator script"
chroot extracted /root/generate.sh
echo "\n\nCreated custom image successfully"
