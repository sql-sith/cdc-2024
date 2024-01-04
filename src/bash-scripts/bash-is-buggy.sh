#!/bin/bash

<<'end_comment'

    Overview:
    ---------
    This version of my script has some bugs. Your job is to find them and fix them. To make it
    less confusing to debug the script, I have replaced the silly prompts from my original with
    script with plain English prompts.

    Known Bugs:
    -----------
    Here are (at least some of) the bugs in this script.

        1.  This version displays all the files, no matter what the user enters for 
            their filter string.
        2.  After you fix the first bug, the following bugs _might_ still be present:
            - If the user enters '?' as the pattern to search for, all files are listed.
            - If the user enters '' (by not typing anything before typing ENTER) as the 
            pattern to search for, all files are listed.
        3.  The menu to display sort options is wrong.
            - You can choose to sort by filename, but this is available on the menu three times.
            - There is no way to sort by filename length.
            - THere is no way to sort by the number of vowels in the filename.
        4.  The filenames that are displayed are incorrect.
        5.  The length calculated for the filenames is incorrect.
        6.  Good news! The number of vowels in the filename


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


# constants

# menus
MESSAGE_BAD_CHOICE="Invalid choice. Try again. Please enter the number shown next to the option you choose."
OPTIONS_FILE_SORT="Filename Filename Length Filename Vowel Count"
OPTIONS_FILE_SORT_BREAK="Filename|Filename Length|Filename Vowel Count"

OPTIONS_YESNO="Yes No"
OPTIONS_YESNO_BREAK="Yes"
OPTIONS_YESNO_EXIT="No"

PROMPT_CONTINUE="Would you like to run the program again? "
PROMPT_FILE_SORT="Which field should be used to sort the files? "
PROMPT_FILTER="What string should be used to filter the files? "

# if you want to see each command printed as it is executed, run the script with
# a `--debug` parameter:
if [[ $1 == "--debug" ]]; then
    set -x
fi

# variable initialization:
PS3_HOLD="$PS3"
PS3="Option: "
tmpfile="$(mktemp)"

echo ""
echo "Welcome to $(basename ${0})! Thanks for stopping by."
echo "I no longer have anything in my grammar for which to apologize, as far as I know."
echo ""

# main program:
while [[ true ]]; do
    unset response
    read -p "$PROMPT_FILTER" $response
    filter="*${response}*"

    # prompt for filter string:
    echo ""
    echo "$PROMPT_FILE_SORT"

    select opt in $OPTIONS_FILE_SORT; do
        if [[ "$opt" =~ $OPTIONS_FILE_SORT_BREAK ]]; then
            break
        else
            echo "$MESSAGE_BAD_CHOICE"
        fi
    done
    echo ""

    # find files matching filter:
    files=$(find . -maxdepth 1 -type f -iname "$filter")

    # the `-n` test makes sure $files is (n)ot empty:
    if [[ -n $files ]]; then
        # remove $tmpfile so it doesn't grow during each user loop:
        rm -f $tmpfile
        echo -e "$files" | while read -r file; do
            vowel_count=$(echo "$file" | grep -io '[aeiou]' | wc --lines)
            filename_length=${#file}
            echo "$file$ $filename_length $vowel_count" >> "$tmpfile"
        done

        if [[ "$opt" == "Filename" ]]; then
            sort_key="1"
        elif [[ "$opt" == "FilenameLength" ]]; then
            sort_key="2h"
        elif [[ "$opt" == "FilenameVowelCount" ]]; then
            sort_key="3h"
        else
            msg=$(fortune)
            msg+="\n\n"
            msg+="This section of code should not be reachable. Exiting."
            echo -e $msg >&2
            set +x
            exit 1
        fi

        (
            echo "Filename FilenameLength FilenameVowelCount";
            echo "-------- -------------- ------------------";
            sort -k $sort_key -t " " "$tmpfile"
        ) | column -t -s " "
    else
        echo "No matching files found."
    fi

    # check if user wants to repeat program:
    echo ""
    echo "$PROMPT_CONTINUE"

    select opt in $OPTIONS_YESNO; do
        if [[ "$opt" =~ $OPTIONS_YESNO_BREAK ]]; then
            break
        elif [[ "$opt" =~ $OPTIONS_YESNO_EXIT ]]; then
            set +x
            exit 0
        else
            echo "$MESSAGE_BAD_CHOICE"
        fi
    done
    echo ""
done

# cleanup
rm -f "$tmpfile"
PS3="$PS3_HOLD"
set +x
