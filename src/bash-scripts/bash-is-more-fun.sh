#!/bin/bash

<<'end_comment'

    This version of my script has some intermediate techniques in it. Please ask if you 
    want me to review what any of them do or how they work. Some of the changes from
    `bash-is-fun-01.sh` include:

        -   Parsing for two command-line flags:
            o   --debug will print a couple of side-by-side hex and ascii data dumps
                at useful times
            o   --trace will turn on `-x` (xtrace) so that bash will print (a
                representation of) every command before it is executed.
        -   The use of bash's arrays. This feature is specific to bash, and is not
            guaranteed to be available using the same syntax in other shells.
        -   Those arrays allow me to use options with the `select` command that have 
            whitespace in them. There may be other ways to do this.

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
OPTIONS_FILE_SORT=("Filename" "Filename Length" "Filename Vowel Count")
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

    select opt in "${OPTIONS_FILE_SORT[@]}"; do
        if [[ "$opt" =~ $OPTIONS_FILE_SORT_BREAK ]]; then
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

        # The way to do this without hard-coded strings uses bash associative arrays.
        # I was going to leave that for another day but since Henry worked with bash 
        # arrays in his solution, please see `bash-has-arrays.sh` in this folder to
        # see how that works.
        if [[ "$opt" == "Filename" ]]; then
            sort_key="1"
        elif [[ "$opt" == "Filename Length" ]]; then
            sort_key="2h"
        elif [[ "$opt" == "Filename Vowel Count" ]]; then
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
            # called the Help Desk so we knew that we had an unhandled error in our code. :)

            msg=$(fortune)
            msg+="\n\n"
            msg+="Did you bad a bad thing at. Script you get my out you of. Thank you."
            echo -e $msg >&2
            set +x
            exit 1
        fi

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
