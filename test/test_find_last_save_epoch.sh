#!/bin/bash

# test suite for testing the find_last_save_epoch script
# the test set should be run after the setup.sh file has been ran in the test_share folder
# and there is no mounted shared folder in share

#TEST: no saves present
echo "TEST: no saves present"

#arrange
ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them

#act
cd ../ && output=$(bash src/find_last_save_epoch.sh test_share/backup); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "4" ]; then
    echo -e "\nPASS: exit code was 4\n"
else 
    echo -e "\nFAIL: exit code was expected to be 4 but was not - exit code was: $exitCode\n"
fi

#TEST: one save present
echo "TEST: one save present"

#arrange
ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them
mkdir ../test_share/backup/nfsbackup_1234560

#act
cd ../ && output=$(bash src/find_last_save_epoch.sh test_share/backup); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [ "$output" -eq 1234560 ]; then
        echo -e "\nPASS: returned last epoch successfully\n"
    else
        echo -e "\nFAIL: last epoch was not equal to the greatest epoch. Expected: 1234560 actual: $output\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 0 but was not - exit code was: $exitCode\n"
fi

#TEST: multiple saves present
echo "TEST: one save present"

#arrange
ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them
mkdir ../test_share/backup/nfsbackup_1234560
mkdir ../test_share/backup/nfsbackup_1566399087


#act
cd ../ && output=$(bash src/find_last_save_epoch.sh test_share/backup); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [ "$output" -eq 1566399087 ]; then
        echo -e "\nPASS: returned last epoch successfully\n"
    else
        echo -e "\nFAIL: last epoch was not equal to the greatest epoch. Expected: 1566399087 actual: $output\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 0 but was not - exit code was: $exitCode\n"
fi

#clean up
ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them

