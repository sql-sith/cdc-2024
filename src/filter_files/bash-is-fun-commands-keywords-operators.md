# Keywords, commands, and operators

The following keywords, commands, and operators are used in (the non-buggy version of) `bash-is-fun-01.sh`. This document is to point out how, although there are 

| Keyword, Symbol, or Operator | Usage                                                                                    |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| =                             | To assign values to variable names, such as `first_name="Chris"`.                      |
| basename                      | To get the base filename only from a file reference that might include path information. |
| break                         | To unconditionally exit (while and select) loops.                                        |
| column                        | To make the output look nicer.                                                           |
| echo                          | To write information to the screen.                                                      |
| exit                          | To unconditionally exit the script.                                                      |
| find                          | To find files matching the filter supplied by the user (I did not use `ls`).           |
| grep                          | To find vowels.                                                                          |
| if/then/elif/else/fi          | For conditional logic.                                                                   |
| mktemp                        | To create a temp file for storing file info.                                             |
| read                          | To prompt the user for input.                                                            |
| rm                            | To delete the temp file created with `mktemp`.                                         |
| select/do/done                | To display simple menus                                                                  |
| sort                          | To send the data requested by the user to the `column` command.                        |
| wc                            | To count vowels.                                                                         |
| while/do/done                 | To create an infinite loop so the user can run the main program logic repeatedly.        |

We'll review how I used each of these at a later meeting.
