#!/bin/bash

# this file is in charge of removing the old backup and creating a new one.
# arg 1 is the shared folder (nfs) location
# arg 2 is the backup folder location
# arg 3 is the current timestamp to append to the backup

sharedFolderLoc=$1
backupFolderLoc=$2
timestamp=$3

if ! ls -A1q "$sharedFolderLoc" | grep -q .; then 
    echo "$sharedFolderLoc appears to not be mounted - directory was empty. Stopping backup" 1>&2;
    exit 2
fi

backupFolderName="nfsbackup_$timestamp"
backupFolderPath="$backupFolderLoc/$backupFolderName"

echo "Saving files to $backupFolderPath"
cp -r "$sharedFolderLoc" "$backupFolderPath"

if [ -z "$(ls -a $backupFolderPath)" ]; then 
    echo "something went wrong copying files, the backup folder: $backupFolderPath is empty. Skipping removal of old saves" 1>&2;
    exit 3
fi

currentDirectory=$(pwd)

echo "Removing old save"
cd "$backupFolderLoc"
ls | grep -P "^(?!($backupFolderName)$).*$" | xargs -r -d"\n" rm -r #remove every backup that is not the current backup
cd "$currentDirectory"

exit 0