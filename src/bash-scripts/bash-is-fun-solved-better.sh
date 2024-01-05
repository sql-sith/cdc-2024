#!/bin/bash

<<'end_comment'

    This version of my script has some intermediate techniques in it. Please ask if you 
    want me to review what any of them do or how they work. Some of the changes from
    `bash-is-fun.sh` include:

        -   Parsing for two command-line flags:
            o   The --debug flag will print a couple of side-by-side hex and ascii data
                dumps at useful times.
            o   The --trace will turn on `-x` (xtrace) so that bash will print (a
                representation of) every command before it is executed.
        -   The use of bash's' arrays. This feature is specific to bash, and is not
            guaranteed to be available using the same syntax in other shells.
            o   This is for you, henry. :)
            o   An indexed array is used to hold "yes" and "no" as possible options for
                the `select` menu that asks the user if they'd like to repeat the
                program. an indexed array uses arbitrary integers as the index.
            o   An associative array is used to hold the possible options for sort order.
                an associative array can use arbitrary strings as the index. this allows
                you to associate each sort order with its sort information. for example,
                so the array knows that the "filename" sort is on the temp file's first
                column, for example.
        -   I've moved user-facing strings into variables, except for messages in debug
            code. This is a good practice for a couple of reasons.
            o   It makes it easier to change the text of a message that's used in
                multiple places, because you only have to change it in one place.
            o   In production programming, strings are frequently moved into a separate
                file, so that different languages can be supported without changing the
                program itself. This process is called "internationalization" or "i18n."
                Separating strings into variables is the first step in this process. The
                next step would be to read the variables from a resource file containing 
                translations of the strings in the user's preferred language.

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


# parameter parsing:
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--debug) debug=1 ;;
        -t|--trace) set -x ;;
        -u|--nounset) set -u ;;
        *) echo "Unknown parameter passed: $1. Program exiting."; exit 3 ;;
    esac
    shift
done


# constant declarations:

# if I could use the null character ('\0'), I would, but I can't get `column` to recognize 
# that character as a proper single-character delimiter, so I'll settle for character code 1.
# although this is a legal character for a filename, I've never seen it used in a filename.
FILENAME_DELIMITER=$'\01'

# general metadata:
PROGRAM_NAME="$(basename ${0})"

# generic yes/no options for `select` menus:
OPTIONS_YESNO=("Yes" "No")
OPTIONS_YESNO_BREAK="^(Yes)$"
OPTIONS_YESNO_EXIT="^(No)$"

# string to filter files:
OPTIONS_FILTER_PROMPT="What string should be used to filter the files? "
OPTIONS_FILTER_PROMPT_REPRIMAND="Invalid filter string entered. Try again. "

# options for sorting files:
OPTIONS_SORT_PROMPT="Which field should be used to sort the files? "

declare -A OPTIONS_SORT
OPTIONS_SORT["Filename"]="1"
OPTIONS_SORT["Filename Length"]="2h"
OPTIONS_SORT["Filename Vowel Count"]="3h"
OPTIONS_SORT_BREAK="^(Filename|Filename Length|Filename Vowel Count)$"

# having a --debug flag allows you to do diagnositics or testing only when that flag is set.
# in debug mode only, make sure we don't match on substring or regex:
if [[ $debug == 1 ]]; then 
    OPTIONS_SORT["Vowel"]="1r";
    OPTIONS_SORT["e"]="2r"
    OPTIONS_SORT[" "]="3r"
    OPTIONS_SORT["."]="1h"
    OPTIONS_SORT[".*"]="1hr"
fi

# prompt to continue or exit:
OPTIONS_CONTINUE_PROMPT="Would you like to run the program again? "

OUTPUT_HEADERS="Filename${FILENAME_DELIMITER}Filename Length${FILENAME_DELIMITER}Filename Vowel Count\n"
OUTPUT_HEADERS+="--------${FILENAME_DELIMITER}---------------${FILENAME_DELIMITER}--------------------\n"

# general-use messages:
MESSAGE_BAD_CHOICE="Invalid choice ($opt)."
MESSAGE_WELCOME="Welcome to ${PROGRAM_NAME}!\n"
MESSAGE_WELCOME+="Thanks for stopping by."
MESSAGE_NO_FILES_FOUND="No matching files found."

# the select menu uses the PS3 prompt:
PS3="Enter the number next to your choice: "

# other variable assignments:
tmpfile="$(mktemp)"


# welcome matt:
echo ""
echo -e "$MESSAGE_WELCOME"
echo ""


# main program:
while [[ true ]]; do

    # get the filter pattern from the user:
    unset response
    CURRENT_PROMPT_FILTER="$OPTIONS_FILTER_PROMPT"
    while [[ -z "$response" ]]; do
        read -p "$CURRENT_PROMPT_FILTER" response
        CURRENT_PROMPT_FILTER="$OPTIONS_FILTER_PROMPT_REPRIMAND"
    done
    filter="*${response}*"

    # get the sort order from the user:
    echo ""
    echo "$OPTIONS_SORT_PROMPT"

    select opt in "${!OPTIONS_SORT[@]}"; do
        if [[ "$opt" =~ $OPTIONS_SORT_BREAK ]]; then
            sort_key=${OPTIONS_SORT[$opt]}
            break
        else
            echo "$MESSAGE_BAD_CHOICE"
        fi
    done
    echo ""

    # retrieve files matching the 
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

            echo -e "$base_filename${FILENAME_DELIMITER}$filename_length${FILENAME_DELIMITER}$vowel_count" >> "$tmpfile"
        done

        if [[ $debug == 1 ]]; then
            echo ""
            echo "Here is a hex/ascii dump of the headers:"
            echo -e "$OUTPUT_HEADERS" | xxd -g 4
            echo ""
            echo "Here is a hex/ascii dump of the first 5 lines of ${tmpfile}:"
            head --lines=5 "$tmpfile" | xxd -g 4
            echo ""
        fi
        (
            echo -e "$OUTPUT_HEADERS";
            sort -k $sort_key -t "${FILENAME_DELIMITER}" "$tmpfile"
        ) | column -t -s "${FILENAME_DELIMITER}"
    else
        echo "$MESSAGE_NO_FILES_FOUND"
    fi

    echo ""
    echo "$OPTIONS_CONTINUE_PROMPT"

    select opt in ${OPTIONS_YESNO[*]}; do
        if [[ "$opt" =~ $OPTIONS_YESNO_BREAK ]]; then
            break
        elif [[ "$opt" =~ $OPTIONS_YESNO_EXIT ]]; then
            exit 0
        else
            echo "$MESSAGE_BAD_CHOICE"
        fi
    done
    echo ""
done

# cleanup
rm -f "$tmpfile"
