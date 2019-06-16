#!/bin/bash

source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/env.sh"

COMMA_DATA_FILE="${DATADIR}/people.csv"
TAB_DATA_FILE="${DATADIR}/people.tsv"


########################################################################

example 0 "The Data: One record per line"

echo  "[ Field Separator: Comma ',' ]"
echo '$' cat "${COMMA_DATA_FILE}"
cat "${COMMA_DATA_FILE}"

echo

echo  "[ Field Separator: Tab '\\t' ]"
echo '$' cat "${TAB_DATA_FILE}"
cat "${TAB_DATA_FILE}"


# this will be used later to expand the single-char
# codes into full names
show_sex() {
    case "$1" in
        M)  echo "Male"     ;;
        F)  echo "Female"   ;;
        I)  echo "Intersex" ;;
        *)  echo "Other"    ;;
    esac
}

########################################################################

example "Reading one line at a time"

echo "Reading data file \"${COMMA_DATA_FILE}\""
while read LINE
do
    # LINE does not contain the newline character
    # that separates lines
    echo "Got a line: '${LINE}'"

    # we redirect the input of the 'while' builtin command!
    # (you can also pipe ("|") into 'while')
done < "${COMMA_DATA_FILE}"


########################################################################

example "Splitting the line into separate fields"

echo "   WARNING: While this is a powerful technique that works,"
echo "            messing with IFS can be hazardous!"
echo "            (see the neighboring script comments)"
echo

# whenever you are messing with IFS, it's always a good
# idea to back it up and restore it *promptly*, because
# when IFS is set to non-standard values, your *debug
# messages* and *general arg handling throughout bash*
# can get messed up. When using this technique, it's best
# to always protect the real IFS value, and isolate/limit
# the code that has to run in a modified-IFS state.

# save the real IFS contents into a backup variable
oldIFS="${IFS}"

# set a new value for IFS *only on the call to 'read'*
#
# in general, if you add VAR=VALUE strings to an otherwise
# complete command to run a program, bash will treat that as
# "setting a variable" temporarily for that single command
# (not as another arg passed to the program)
#
# FOO=1
# prog -with -args         # prog sees $FOO with value "1"
# prog -with -args FOO=2   # prog sees $FOO with value "2"
# FOO=3 prog -with -args   # prog sees $FOO with value "3"
#                          # in all 3, prog sees two args [-with, -args]

# make read split words on ',' instead of whitespace
# (while already split the input on newlines)
while IFS="," read NAME AGE SEX
do
    # do something with the fields
    echo -n -e "${NAME}:\tage=${AGE} sex="
    show_sex "${SEX}"
    
done < "${COMMA_DATA_FILE}"

# restore IFS to its original value
IFS="${oldIFS}"


##########################################################################

example "Easier wordsplitting with tab '\\t'"

# The 'tab' character was intended as record separator,
# because characters like ',' are that are commonly used
# in records introduce an annoying in-band-sigling problem.
# If you can guarantee your data does not include the
# tab '\t' character (or newlines '\n'), the shell can
# split lines into fields without changing IFS.
#
# By default, IFS is set to three whitespacd characters:
# space, tab, and newline.
#
#     IFS=" \t\n"
#
# (single quote strings that start with '$' like $'string'
#  expand escape sequences like '\n' (newline)  or
#  '\uHHHH' (Unicode code point up to 4 hex-digits long)
#
# (why single quotes? The double quote version $"string"
#  use the current locale when deciding how to expand
#  special characters. This is for human interactive
#  situations; it's a good idea to avoid things that
#  might break your script unexpectedly).

while read NAME AGE SEX
do
    # do something with the fields
    echo -n -e "${NAME}:\tage=${AGE} sex="
    show_sex "${SEX}"

done < "${TAB_DATA_FILE}"


##########################################################################

end_of_examples
