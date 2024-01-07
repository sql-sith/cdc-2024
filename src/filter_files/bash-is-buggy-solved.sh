#!/bin/bash

<<'end_comment'

    Overview:
    ---------
    This version of the script is simply a debugged version of bash-is-buggy.sh.

    Known Bugs (this refers to the original bash-is-buggy.sh script, not this one):
    -----------
    Here are (at least some of) the bugs in this script.

        1.  The file information is displayed incorrectly.
            o The filenames have a "$" at the end of them.
            o The filename length is incorrect.
            o But rejoice somewhat, as the number of vowels in the filename may well be correct!
        2.  This version displays all the files, no matter what the user enters for 
            their filter string.
        3.  After you fix the previous bug, the following bug might still be present:
            - If the user enters '' (by not typing anything before typing ENTER) as the 
            pattern to search for, all files are listed.
        3.  The menu to display sort options is wrong.
            - You can choose to sort by filename, but this is available on the menu three times.
            - There is no way to sort by filename length.
            - THere is no way to sort by the number of vowels in the filename.


    Script Specification:
    ---------------------
    Description:
        This script displays a filtered and sorted list of files in the current directory.
    
    Program flow:
        1.  Ask user for character string that will be used to filter the names of files
            displayed. Only files that match this string will be shown. Call the supplied
            string FILTER.
        2.  Ask user to choose from a list of possible sort orders for the list of files.
            Call the chosen option SORT_OPTION.
        3.  Display information about the files that have names matching FILTER. Show this
            information file-by-file such that the order of the files matches SORT_OPTION.

end_comment

# variable initialization:
tmpfile="$(mktemp)"
delimiter='/'

# the select menu will use this prompt:
PS3="Enter the number next to your choice: "

echo ""
echo "Welcome to $(basename ${0})! Thanks for stopping by."
echo "I no longer have anything in my grammar for which to apologize, as far as I know."
echo ""

# main program:
while [[ true ]]; do
    unset response
    read -p "What string should be used to filter the files? " response
    filter="*${response}*"

    # prompt for filter string:
    echo ""
    echo "Which field should be used to sort the files? "

    select opt in "Filename" "Filename Length" "Filename Vowel Count"; do
        echo "$opt"
        if [[ "$opt" =~ (Filename|Filename Length|Filename Vowel Count) ]]; then
            break
        else
            echo "Invalid choice. Try again. Please enter the number shown next to the option you choose."
        fi
    done
    echo ""

    if [[ "$opt" == "Filename" ]]; then
        sort_key="1"
    elif [[ "$opt" == "Filename Length" ]]; then
        sort_key="2h"
    elif [[ "$opt" == "Filename Vowel Count" ]]; then
        sort_key="3h"
    else
        msg=$(fortune)
        msg+="\n\n"
        msg+="This section of code should not be reachable. Exiting."
        echo -e $msg >&2
        exit 1
    fi
    echo $sort_key "<<<----"
    # find files matching filter:
    files=$(find . -maxdepth 1 -type f -iname "$filter")

    # the `-n` test makes sure $files is (n)ot empty:
    if [[ -n $files ]]; then
        # remove $tmpfile so it doesn't grow during each user loop:
        rm -f $tmpfile
        echo -e "$files" | while read -r file; do
            basename=$(basename "$file")
            vowel_count=$(echo "$basename" | grep -io '[aeiou]' | wc --lines)
            basename_length=${#basename}
            echo "${basename}${delimiter}${basename_length}${delimiter}${vowel_count}" >> "$tmpfile"
        done


        (
            echo "Filename${delimiter}FilenameLength${delimiter}FilenameVowelCount";
            echo "--------${delimiter}--------------${delimiter}------------------";
            sort -k $sort_key -t "${delimiter}" "$tmpfile"
        ) | column -t -s "${delimiter}"
    else
        echo "No matching files found."
    fi

    # check if user wants to repeat program:
    echo ""
    echo "Would you like to run the program again? "

    select opt in "Yes" "No"; do
        if [[ "$opt" == "Yes" ]]; then
            break
        elif [[ "$opt" == "No" ]]; then
            exit 0
        else
            echo "Invalid choice. Try again. Please enter the number shown next to the option you choose."
        fi
    done
    echo ""
done
