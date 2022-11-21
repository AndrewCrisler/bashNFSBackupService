#!/bin/bash

# test suite for testing the symbol_to_epoch script
# the test set should be run after the setup.sh file has been ran in the test_share folder
# and there is no mounted shared folder in share

#TEST: ensure custom integer inputs returns the same
echo "TEST: ensure integer returns the same"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh 1234569); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [[ $output -eq 1234569 ]]; then
        echo -e "\nPASS: Custom epoch period returned correctly \n"
    else
        echo -e "\nFAIL: output was not equal to integer inputed\n"
    fi
else 
    echo -e "\nFAIL: returned non-zero exit code - exit code was: $exitCode\n"
fi

#TEST: ensure d returns a day in epoch time
echo "TEST: ensure d returns a day in epoch time"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh d); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [[ $output -eq $((60 * 60 * 24)) ]]; then
        echo -e "\nPASS: the symbol d successfully returned a day in epoch time\n"
    else
        echo -e "\nFAIL: output was not equal to a day in epoch time\n"
    fi
else 
    echo -e "\nFAIL: returned non-zero exit code - exit code was: $exitCode\n"
fi

#TEST: ensure w returns a week in epoch time
echo "TEST: ensure w returns a week in epoch time"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh w); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [[ $output -eq $((60 * 60 * 24 * 7)) ]]; then
        echo -e "\nPASS: the symbol w successfully returned a week in epoch time\n"
    else
        echo -e "\nFAIL: output was not equal to a week in epoch time\n"
    fi
else 
    echo -e "\nFAIL: returned non-zero exit code - exit code was: $exitCode\n"
fi

#TEST: ensure m returns a month in epoch time
echo "TEST: ensure m returns a month in epoch time"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh m); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [[ $output -eq $((60 * 60 * 24 * 30)) ]]; then
        echo -e "\nPASS: the symbol m successfully returned a month in epoch time\n"
    else
        echo -e "\nFAIL: output was not equal to a month in epoch time\n"
    fi
else 
    echo -e "\nFAIL: returned non-zero exit code - exit code was: $exitCode\n"
fi

#TEST: ensure y returns a year in epoch time
echo "TEST: ensure y returns a year in epoch time"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh y); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "0" ]; then
    if [[ $output -eq $((60 * 60 * 24 * 365)) ]]; then
        echo -e "\nPASS: the symbol y successfully returned a year in epoch time\n"
    else
        echo -e "\nFAIL: output was not equal to a year in epoch time\n"
    fi
else 
    echo -e "\nFAIL: returned non-zero exit code - exit code was: $exitCode\n"
fi

#TEST: random input results in an error
echo "TEST: random input results in an error"

#arrange - not needed

#act
cd ../ && output=$(bash src/symbol_to_epoch.sh 1222wy5); exitCode=$? && cd test

#assert
if [ "$exitCode" -eq "5" ]; then
    echo -e "\nPASS: the script successfully errored out with exit code 5\n"
else 
    echo -e "\nFAIL: the exit code expected was 5 however, the exit code returned was not 5 - exit code was: $exitCode\n"
fi

#clean up - not needed