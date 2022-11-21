#!/bin/bash

# test suite for testing the update_backup.sh script
# the test set should be run after the setup.sh file has been ran in the test_share folder
# and there is no mounted shared folder in share

#TEST: test creating backup with no prior backups
echo "TEST: test creating backup with no prior backups"

#arrange
touch ../test_share/share/test_file.txt

rm -r ../test_share/backup/*

#act
cd ../ && bash src/update_backup.sh test_share/share test_share/backup 1234567 && cd test

#assert
if [ -f "../test_share/backup/nfsbackup_1234567/test_file.txt" ]; then
    echo -e "\nPASS: test_file successfully saved with new backup\n"
else
    echo -e "\nFAIL: test_file could not be found, backup must not have saved correctly\n"
fi

#TEST: creating backup with a prior backup
echo "TEST: creating backup with a prior backup"

#arrange
touch ../test_share/share/test_file.txt

rm -r ../test_share/backup/*

#act
cd ../ && bash src/update_backup.sh test_share/share test_share/backup 1234560 && cd test
cd ../ && bash src/update_backup.sh test_share/share test_share/backup 1234564 && cd test


#assert
if [ -f "../test_share/backup/nfsbackup_1234564/test_file.txt" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_1234560/test_file.txt" ]; then
        echo -e "\nPASS: test_file successfully saved with new backup\n"
    else 
        echo -e "\nFAIL: old backup still exists and was not removed\n"
    fi
else
    echo -e "\nFAIL: test_file could not be found, backup must not have saved correctly\n"
fi

#TEST: do not backup when backup does not exist
echo "TEST: do not backup when backup does not exist"

#arrange
rm -r ../test_share/backup/*
rm -r ../test_share/share/*

#act
cd ../ && bash src/update_backup.sh test_share/share test_share/backup 1234569; exitCode=$? && cd test


#assert
if [ "$exitCode" -eq "2" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_1234569/test_file.txt" ]; then
        echo -e "\nPASS: no folder was created and exit code was 2\n"
    else
        echo -e "\nFAIL: backup folder was still created despite the correct error code\n"
    fi
else 
    echo -e "\nFAIL: exit code did not equal 2 - exit code was: $exitCode\n"
fi

#clean up
ls -A1q ../test_share/share | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them
ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them
