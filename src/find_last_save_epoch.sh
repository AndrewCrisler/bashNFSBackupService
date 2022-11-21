#!/bin/bash

#This file will find the last save created and return its epoch timestamp
#arg 1 - the location of the backup folder

backupFolderLoc=$1

currentDirectory=$(pwd)
greatestTimestamp=-1

cd "$backupFolderLoc"

for value in $(ls | grep -P "^nfsbackup_[0-9]+$" | xargs -r -d"\n" echo)
do
    timestamp=${value:10}
    if [[ $timestamp -gt $greatestTimestamp ]]; then
        greatestTimestamp=$timestamp
    fi
done
cd "$currentDirectory"

if [[ $greatestTimestamp -eq -1 ]]; then
    echo "No timestamps could be found" 1>&2;
    exit 4
fi

echo $greatestTimestamp
exit 0
