#!/bin/bash

PATH=/sbin:/usr/sbin:/bin:/usr/bin

. /lib/init/vars.sh
. /lib/lsb/init-functions

rootdev=`blkid -U @@UUID_ROOTFS@@`

dev=${rootdev%??}
lba_start=`fdisk -l ${dev} | grep p2 | awk '{print $2}'`
lba_finish=$((`fdisk -l ${dev} | grep Disk | grep sectors | awk '{printf $7}'` - 2048))

echo -e "p\nd\n2\nn\np\n2\n${lba_start}\n${lba_finish}\np\nw\n" | \
	fdisk ${dev} >/dev/null
resize2fs ${rootdev}

rm -f /etc/ssh/ssh_host* && ssh-keygen -A

exit 0
