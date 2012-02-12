#!/bin/bash

## author: Christian Pietsch <chr.pietsch+github at GoogleMail>
## date released: 12 February 2012
## licence: GPLv3
## purpose: full backup script

## writes a clone of /dev/sda onto the next hard disk with identical partition layout

DEVPREFIX="/dev/sd"
SOURCE="a"
PROBESOURCE=$(fdisk -l "${DEVPREFIX}${SOURCE}" | tail -n +10 | cut -d' ' -f 2-)

if [ $# > 0 ]
then
    echo "Usage: This script is intended to make sure that repeat backups are not"
    echo "       written to the wrong drive. It assumes that you have mounted a"
    echo "       drive containing a previous full disk backup created independently,"
    echo "       perhaps using a command like this: dd if=sda of=sdX."
    echo "       Currently this script does not take any arguments. You need to"
    echo "       specify the source drive in the source code if it is not /dev/sda."
fi

if [ "x${PROBESOURCE}" == "x" ]
then
    echo "You need to be root to do this."
    exit 2
fi

for DEST in b c d e f z
do
    PROBEDEST=$(fdisk -l "${DEVPREFIX}${DEST}" | tail -n +10 | cut -d' ' -f 2-)

    #echo -n "Destination: "
    #echo "${DEVPREFIX}${DEST}"
    #echo "${PROBEDEST}"

    if [ "${PROBESOURCE}" == "${PROBEDEST}" ]
    then
	echo "I am going to copy ${DEVPREFIX}${SOURCE} to ${DEVPREFIX}${DEST}. This is the last chance to hit CTRL c."
	read
	echo "Please be really patient now ..."
	dd if="${DEVPREFIX}${SOURCE}" conv=noerror,sync bs=64k | dd of=${DEVPREFIX}${DEST} bs=64k && echo "Finished cloning successfully." || echo "dd reported a problem: $?"
	exit 0;
    fi
done

echo "No identically partitioned destination disk found. Aborting."
exit 1
