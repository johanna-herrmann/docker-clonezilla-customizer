#!/bin/sh

spacer="\n\n\n"

# alwys use /opt/work as workdirectory inside
if [ -d "/github/workspace" ]
then
    ln -nsf /github/workspace /opt/work
fi
workdir=/opt/work

# extract base iso
mkdir iso
mkdir squash
mkdir -p extracted/run/live/medium/
mount -o loop $workdir/clonezilla.iso iso
mount -t squashfs iso/live/filesystem.squashfs squash
rsync -auvx --progress squash/ extracted/
rsync -auvx --progress iso/ extracted/run/live/medium/

# add extra files if given
if [ -d "$workdir/extra" ]
then
    mkdir -p extracted/run/live/medium/live/extra
    rsync -auvx --progress "$workdir/extra" extracted/run/live/medium/live/extra/
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
