#!/bin/sh

spacer="\n\n\n"

# always use /opt/work as workdirectory inside
if [ -d "/github/workspace" ]
then
    ln -nsf /github/workspace /opt/work
fi
workdir=/opt/work

# extract base iso
mkdir iso
mkdir extracted
xorriso -osirrox on -indev $workdir/clonezilla.iso -extract / iso
unsquashfs -d extracted iso/live/filesystem.squashfs
mkdir -p extracted/run/live/medium
mount --bind iso extracted/run/live/medium

# add extra files if given
if [ -d "$workdir/extra" ]
then
    mkdir -p extracted/run/live/medium/live/extra
    mount --bind "$workdir/extra" extracted/run/live/medium/live/extra
fi

# copy generator
cp generate.sh extracted/root/
chmod a+x extracted/root/generate.sh

# mount workdir
mkdir -p extracted/root/work
mount --bind "$workdir" extracted/root/work

# dev and proc binding
mount --bind /dev extracted/dev
mount --bind /proc extracted/proc

# generate
chroot extracted /root/generate.sh
