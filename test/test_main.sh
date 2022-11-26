#!/bin/bash

# test suite for testing the main.sh script
# the test set should be run after the setup.sh file has been ran in the test_share folder
# and there is no mounted shared folder in share

#setup: 

# arg1: nfs folder dir
# arg2: backup dir
# arg3: backup interval
createConfig () {
    echo -e "nfs_folder_dir=$1\nbackup_dir=$2\nbackup_interval=$3" > "../test_share/test_config.txt"
}

cleanupTestShare () {
    ls -A1q ../test_share/share | grep -q . && rm -r ../test_share/share/* #if files exist, remove them
    ls -A1q ../test_share/backup | grep -q . && rm -r ../test_share/backup/* #if files exist, remove them
}

#TEST: save needs an update
echo "TEST: save needs an update"

#arrange
cleanupTestShare

createConfig "test_share/share" "test_share/backup" "10"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_89

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [ -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        echo -e "\nPASS: created a new save correctly\n"
    else
        echo -e "\nFAIL: test_file did not correctly show up in a new backup\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 0 but was not - exit code was: $exitCode\n"
fi

#TEST: save does not need an update
echo "TEST: save does not need an update"

#arrange
cleanupTestShare

createConfig "test_share/share" "test_share/backup" "10"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_91
echo "old save" > ../test_share/backup/nfsbackup_91/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        if [ -f "../test_share/backup/nfsbackup_91/test_file.txt" ]; then
            echo -e "\nPASS: both the old save exists and a new save was not created\n"
        else
            echo -e "\nFAIL: old save could not be found\n"
        fi
    else
        echo -e "\nFAIL: the program created a new save when it should not have\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 0 but was not - exit code was: $exitCode\n"
fi

#TEST: nfs folder dir does not exist
echo "TEST: nfs folder dir does not exist"

#arrange
cleanupTestShare

echo -e "backup_dir=$2\nbackup_interval=$3" > "../test_share/test_config.txt"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_91
echo "old save" > ../test_share/backup/nfsbackup_91/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "6" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        if [ -f "../test_share/backup/nfsbackup_91/test_file.txt" ]; then
            echo -e "\nPASS: both the old save exists and a new save was not created and the exit code was 6\n"
        else
            echo -e "\nFAIL: old save could not be found\n"
        fi
    else
        echo -e "\nFAIL: the program created a new save when it should not have\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 6 but was not - exit code was: $exitCode\n"
fi

#TEST: backup dir does not exist
echo "TEST: backup dir does not exist"

#arrange
cleanupTestShare

echo -e "nfs_folder_dir=$1\nbackup_interval=$3" > "../test_share/test_config.txt"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_91
echo "old save" > ../test_share/backup/nfsbackup_91/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "6" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        if [ -f "../test_share/backup/nfsbackup_91/test_file.txt" ]; then
            echo -e "\nPASS: both the old save exists and a new save was not created and the exit code was 6\n"
        else
            echo -e "\nFAIL: old save could not be found\n"
        fi
    else
        echo -e "\nFAIL: the program created a new save when it should not have\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 6 but was not - exit code was: $exitCode\n"
fi

#TEST: backup interval does not exist
echo "TEST: backup interval does not exist"

#arrange
cleanupTestShare

echo -e "nfs_folder_dir=$1\nbackup_dir=$2" > "../test_share/test_config.txt"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_91
echo "old save" > ../test_share/backup/nfsbackup_91/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "6" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        if [ -f "../test_share/backup/nfsbackup_91/test_file.txt" ]; then
            echo -e "\nPASS: both the old save exists and a new save was not created and the exit code was 6\n"
        else
            echo -e "\nFAIL: old save could not be found\n"
        fi
    else
        echo -e "\nFAIL: the program created a new save when it should not have\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 6 but was not - exit code was: $exitCode\n"
fi

#TEST: bad interval given in config
echo "TEST: bad interval given in config"

#arrange
cleanupTestShare

createConfig "test_share/share" "test_share/backup" "ww"

echo "test" > ../test_share/share/test_file.txt

mkdir ../test_share/backup/nfsbackup_89
echo "old save" > ../test_share/backup/nfsbackup_89/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "5" ]; then
    if [ ! -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        if [ -f "../test_share/backup/nfsbackup_89/test_file.txt" ]; then
            echo -e "\nPASS: both the old save exists and a new save was not created and the exit code was 5\n"
        else
            echo -e "\nFAIL: old save could not be found\n"
        fi
    else
        echo -e "\nFAIL: the program created a new save when it should not have\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 5 but was not - exit code was: $exitCode\n"
fi

#TEST: no old save found
echo "TEST: no old save found"

#arrange
cleanupTestShare

createConfig "test_share/share" "test_share/backup" "10"

echo "test" > ../test_share/share/test_file.txt

#act
cd ../ && output=$(bash src/main.sh test_share/test_config.txt 100); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [ -f "../test_share/backup/nfsbackup_100/test_file.txt" ]; then
        echo -e "\nPASS: created a new save correctly\n"
    else
        echo -e "\nFAIL: test_file did not correctly show up in a new backup\n"
    fi
else 
    echo -e "\nFAIL: exit code was expected to be 0 but was not - exit code was: $exitCode\n"
fi

#clean up:
cleanupTestShare
[ -f ../test_share/test_config.txt ] && rm ../test_share/test_config.txt

