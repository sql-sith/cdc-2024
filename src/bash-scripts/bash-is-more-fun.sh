#!/bin/bash

<<'end_comment'

    This version of my script has some intermediate techniques in it. Please ask if you 
    want me to review what any of them do or how they work. Some of the changes from
    `bash-is-fun-01.sh` include:

        -   Parsing for two command-line flags:
            o   the --debug flag will print a couple of side-by-side hex and 
                ascii data dumps at useful times
            o   the --trace will turn on `-x` (xtrace) so that bash will print
                (a representation of) every command before it is executed.
        -   The use of bash's arrays. This feature is specific to bash, and is not
            guaranteed to be available using the same syntax in other shells.
            o   this is for you, henry. :)
            o   an indexed array is used to hold "yes" and "no" as possible options 
                for the `select` menu that asks the user if they'd like to repeat
                the program. an indexed array uses arbitrary integers as the index.
            o   an associative array is used to hold the possible options for sort
                order. an associative array can use arbitrary strings as the index.
                this allows me to associate each sort order with its sort information.
                so the array knows that the "filename" sort is on my temp file's first
                column, for example.

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
        *) echo "Unknown parameter passed: $1"; set +x; exit 3 ;;
    esac
    shift
done


# constant declarations:

# if I could use the null character ('\0'), I would, but I can't get `column` to recognize 
# that character as a proper single-character delimiter, so I'll settle for character code 1.
# although this is a legal character for a filename, I've never seen it used in a filename.
FILENAME_DELIMITER=$'\01'

MESSAGE_BAD_CHOICE="Option; please it bad! Again try above."

# OPTIONS_FILE_SORT=("Filename" "Filename Length" "Filename Vowel Count")
declare -A OPTIONS_FILE_SORT
OPTIONS_FILE_SORT["Filename"]="1"
OPTIONS_FILE_SORT["Filename Length"]="2h"
OPTIONS_FILE_SORT["Filename Vowel Count"]="3h"

 # make sure we don't match on substring or regex:
if [[ $debug == 1 ]]; then 
    OPTIONS_FILE_SORT["Vowel"]="1r";
    OPTIONS_FILE_SORT["e"]="2r"
    OPTIONS_FILE_SORT[" "]="3r"
    OPTIONS_FILE_SORT["."]="1h"
    OPTIONS_FILE_SORT[".*"]="1hr"
fi

OPTIONS_FILE_SORT_BREAK="^(Filename|Filename Length|Filename Vowel Count)$"

OPTIONS_YESNO=("Yes" "No")
OPTIONS_YESNO_BREAK="^(Yes)$"
OPTIONS_YESNO_EXIT="^(No)$"

PROMPT_CONTINUE="Again continue go to which for more for? Guess. "
PROMPT_FILE_SORT="Us which field you data by sorting the files the screen onto be wanting to be? Tell. "
PROMPT_FILTER="By what string with which filtering the files this directory in? Type. "
PROMPT_FILTER_REPRIMAND="Not empty enter! Type right which filtering by here directory files in! Now. "

OUTPUT_HEADERS="Filename${FILENAME_DELIMITER}Filename Length${FILENAME_DELIMITER}Filename Vowel Count\n"
OUTPUT_HEADERS+="--------${FILENAME_DELIMITER}---------------${FILENAME_DELIMITER}--------------------\n"


# variable assignments:
PS3_HOLD="$PS3"
PS3="Option: "
tmpfile="$(mktemp)"


# welcome matt:
echo ""
echo "Welcome $(basename ${0}) to!!!"
echo "  I'm glad you've come to visit for."
echo "  Dan is sorry I am you to."
echo ""


# main program:
while [[ true ]]; do

    # get the filter pattern from the user:
    unset response
    CURRENT_PROMPT_FILTER="$PROMPT_FILTER"
    while [[ -z "$response" ]]; do
        read -p "$CURRENT_PROMPT_FILTER" response
        CURRENT_PROMPT_FILTER="$PROMPT_FILTER_REPRIMAND"
    done
    filter="*${response}*"

    # get the sort order from the user:
    echo ""
    echo "$PROMPT_FILE_SORT"

    select opt in "${!OPTIONS_FILE_SORT[@]}"; do
        if [[ "$opt" =~ $OPTIONS_FILE_SORT_BREAK ]]; then
            sort_key=${OPTIONS_FILE_SORT[$opt]}
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
        echo "No matching files found."
    fi

    echo ""
    echo "$PROMPT_CONTINUE"

    select opt in ${OPTIONS_YESNO[*]}; do
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
