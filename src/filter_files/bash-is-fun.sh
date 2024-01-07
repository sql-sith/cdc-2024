#!/bin/bash

# prompt user for character string:
#   - filter files in the current directory by character string

# sort them by:
#   - alphabetically by name
#   - file length
#   - number of vowels


# prompt user for character string:
# tristan: read
read -p "By what string with which filtering the files this directory in? " filter


# Tell us field which by to sort with:
#
#   1) file name
#   2) length of file name 
#   3) number of vowels in file name
#
# Pick one: 

# chris: already knew this
OPTIONS="Filename FilenameLength FilenameVowelCount"
select opt in $OPTIONS; do
    if [[ "$opt" =~ Filename|FilenameLength|FilenameVowelCount ]]; then
        break
    else
        echo bad option
    fi
done

# todo: hide `ls` errors; detect with $? and show user-friendly error message
if [[ "$opt" == "Filename" ]]; then
    ls -ld *${filter}*
elif [[ "$opt" == "FilenameLength" ]]; then
    ls -ld # ???
elif [[ "$opt" == "FilenameVowelCount" ]]; then
    ls -ld # ???
else
    echo "Wha???"
    exit 1
fi
