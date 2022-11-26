#!/bin/bash

# This file will get run every time after wakeup from sleep or shutdown. It will check if
# the current backup is expired (older than the period set in the config) and if so, it will
# handle creating a new backup and cleaning up the old backup.

# arg 1 - when present, uses the string as a path to a different config file. Path should be relitive to project root repo
# arg 2 - TESTING ONLY - when present, uses the integer as the current epoch time instead of getting it from the current_time bash script

if [ ! -z "$1" ]; then
    configPath=$1
else
    configPath="config.txt"
fi

if [ ! -z "$2" ]; then
    currentEpoch=$2
else 
    currentEpoch=$(bash src/current_time.sh)
fi

#read in the config
delimiter="="

nfsFolderDirExists="false"
backupDirExists="false"
backupIntervalExists="false"

while read -r line
do
    prefix=${line%%$delimiter*}
    index=${#prefix}
    key=${line:0:index}
    value=${line:$((index + 1))}

    case $key in
        nfs_folder_dir)
            nfsFolderDir=$value
            nfsFolderDirExists="true"
            ;;
        backup_dir)
            backupDir=$value
            backupDirExists="true"
            ;;
        backup_interval)
            backupInterval=$value
            backupIntervalExists="true"
            ;;
        *)
            echo "unknown option: $value"
            ;;
    esac
done < $configPath

if [[ $nfsFolderDirExists == "false" ]] || [[ $backupDirExists == "false" ]] || [[ $backupIntervalExists == "false" ]]; then
    echo "one or more required keys were missing in the config. Please make sure all lines are present in the config.txt file that were present in the template. Aborting backup" 1>&2
    echo "nfs_folder_dir exists: $nfsFolderDirExists" 1>&2
    echo "backup_dir exists: $backupDirExists" 1>&2
    echo "backup_interval exists: $backupIntervalExists" 1>&2
    exit 6
fi

#convert backupInterval to epoch period
epochPeriod=$(bash src/symbol_to_epoch.sh "$backupInterval")
exitCode=$?
if [[ $exitCode -ne 0 ]]; then
    echo "backup interval in config could not be converted to epoch interval. Aborting backup" 1>&2
    exit $exitCode
fi

lastSaveEpoch=$(bash src/find_last_save_epoch.sh "$backupDir")
exitCode=$?
if [[ $exitCode -ne 0 ]]; then
    echo "Assuming first time backing up. Continuing backup"
    lastSaveEpoch=$(( $currentEpoch - $epochPeriod - 1 )) #guarrentees backup
fi

epochDifference=$(( $currentEpoch - $lastSaveEpoch ))

if [[ $epochDifference -gt $epochPeriod ]]; then
    echo "starting backup"
    bash src/update_backup.sh "$nfsFolderDir" "$backupDir" $currentEpoch
else
    echo "no need for backup"
fi