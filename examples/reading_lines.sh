#!/bin/bash

source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/env.sh"

DATAFILE="${DATADIR}/people.csv"


########################################################################

echo "0. The data"
echo
echo '$' cat "${DATAFILE}"
cat "${DATAFILE}"


########################################################################

echo
echo "1. Reading one line at a time"
echo

while read LINE
do
    echo "Got a line: '${LINE}'"
done < "${DATAFILE}"


########################################################################

echo
echo "2. Letting the shell word-split our line"
echo "   (WARNING - messing with IFS can be hazardous!)"
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
    echo -n -e "${NAME}:\tage=${AGE} sex="
    case "${SEX}" in
        M)  echo "Male" ;;
        F)  echo "Female" ;;
        I)  echo "Intersex" ;;
        *)  echo "Other" ;;
    esac
    
done < "${DATAFILE}"

# restore IFS to its original value
IFS="${oldIFS}"
