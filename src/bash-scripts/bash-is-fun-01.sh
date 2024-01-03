#!/bin/bash

<<'end_comment'

    This version of my script has some bugs. For example:
        1.  If the user enters '?' as the pattern to search for, all files are listed.
        2.  If the user enters '.' as the pattern to search for, all files are listed.
        3.  If the user enters '' (by not typing anything before typing ENTER) as the 
            pattern to search for, all files are listed.

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
MESSAGE_BAD_CHOICE="Option; please it bad! Again try above."
OPTIONS_FILE_SORT="Filename FilenameLength FilenameVowelCount"
OPTIONS_FILE_SORT_BREAK="Filename|Filename Length|Filename Vowel Count"

OPTIONS_YESNO="Yes No"
OPTIONS_YESNO_BREAK="Yes"
OPTIONS_YESNO_EXIT="No"

PROMPT_CONTINUE="Again continue go to which for more for? Guess. "
PROMPT_FILE_SORT="Us which field you data by sorting the files the screen onto be wanting to be? Tell. "
PROMPT_FILTER="By what string with which filtering the files this directory in? Type. "
PROMPT_FILTER_REPRIMAND="Not empty enter! Type right which filtering by here directory files in! Now. "

# this delimiter will be used by both `sort` and `column` and should not be
# a legal character for filenames in the filesystem being used by this script.
# both Windows and Linux disallow '/' at the OS level. macOS allows any Unicode
# character, but this depends on what tool you are using. for example, this 
# stackoverflow response says that terminal allows ':' and finder allows '/':
#    https://stackoverflow.com/questions/1976007/what-characters-are-forbidden-in-windows-and-linux-directory-names
#
FILENAME_DELIMITER="/"

if [[ $1 == "--debug" ]]; then
    set -x
fi

# variable assignment
PS3_HOLD="$PS3"
PS3="Option: "
tmpfile="$(mktemp)"

echo ""
echo "Welcome $(basename ${0}) to!!!"
echo "  I'm glad you've come to visit for."
echo "  Dan is sorry I am you to."
echo ""


while [[ true ]]; do
    unset response
    CURRENT_PROMPT_FILTER="$PROMPT_FILTER"
    while [[ -z "$response" ]]; do
        read -p "$CURRENT_PROMPT_FILTER" response
        CURRENT_PROMPT_FILTER="$PROMPT_FILTER_REPRIMAND"
    done
    filter="*${response}*"

    # Tell us field which by to sort with:
    #
    #   1) file name
    #   2) length of file name 
    #   3) number of vowels in file name
    #
    # Pick one: 

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

    # todo: hide `ls` errors; detect with $? and show user-friendly error message.
    #       of course, I didn't use `ls`. :)

    files=$(find . -maxdepth 1 -type f -iname "$filter")
    # make sure $files is not empty
    if [[ -n $files ]]; then
        # remove $tmpfile so it doesn't grow during each user loop:
        rm -f $tmpfile
        echo -e "$files" | while read -r file; do
            
            # strip leading './':
            base_filename=$(basename "$file")
            vowel_count=$(echo "$base_filename" | grep -io '[aeiou]' | wc --lines)
            filename_length="${#base_filename}"

            echo "$base_filename${FILENAME_DELIMITER}$filename_length${FILENAME_DELIMITER}$vowel_count" >> "$tmpfile"
        done

        # The way to do this without hard-coded strings uses bash associative arrays.
        # I was going to leave that for another day but since Henry worked with bash 
        # arrays in his solution, please see `bash-has-arrays.sh` in this folder to
        # see how that works.
        if [[ "$opt" == "Filename" ]]; then
            sort_key="1"
        elif [[ "$opt" == "FilenameLength" ]]; then
            sort_key="2h"
        elif [[ "$opt" == "FilenameVowelCount" ]]; then
            sort_key="3h"
        else
            # You really would want to code this `else` clause, so that if you added another
            # option, or there was an error that let this "impossible" situation occur, you'd
            # at least communicate _something_ to the user. At my first job, I put this in as
            # the default error response, meaning the message we displayed when there was no
            # specific message defined for an error:
            #
            #   CONGRATULATIONS!!! You have won a free trip to Hawaii!
            #   Contact the ADP Help Desk for more info.
            #
            # It did happen, and the user was pretty disappointed, but at least they actually
            # called the Help Desk so we knew that we had an unhandled error in our code.
            #
            # This might have been my most successful social engineering experiment ever, if
            # you don't count the whole thing with the Butter Cows.
            #

            msg=$(fortune)
            msg+="\n\n"
            msg+="Did you still did bad a bad thing at. Now get my script you out of!"
            echo -e $msg >&2
            set +x
            exit 1
        fi

        (
            echo "Filename${FILENAME_DELIMITER}Filename Length${FILENAME_DELIMITER}Filename Vowel Count";
            echo "--------${FILENAME_DELIMITER}---------------${FILENAME_DELIMITER}--------------------";
            sort -k $sort_key -t "${FILENAME_DELIMITER}" "$tmpfile"
        ) | column -t -s "${FILENAME_DELIMITER}"
    else
        echo "No matching files found."
    fi

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
