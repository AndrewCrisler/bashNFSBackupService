#!/bin/bash

# This file takes in a symbol and converts it into the epoch representation.
# The valid symbols are as follows:
# y - a year in epoch
# m - a month in epoch
# w - a week in epoch
# d - a day in epoch
# \d (an integer) - a custom period in epoch time.
# arg1 - the symbol to return its epoch time

symbol=$1

charRe='^(y|m|w|d)$'
if [[ $symbol =~ $charRe ]] ; then
   case $symbol in
        d)
            echo $((60 * 60 * 24))
            ;;
        w)
            echo $((60 * 60 * 24 * 7))
            ;;
        m)
            echo $((60 * 60 * 24 * 30))
            ;;
        y)
            echo $((60 * 60 * 24 * 365))
            ;;
    esac
else
    intRe='^[0-9]+$'
    if [[ $symbol =~ $intRe ]]; then
        echo $symbol
    else
        echo "Cannot understand symbol entered: symbol recieved was $symbol" 1>&2;
        exit 5
    fi
fi