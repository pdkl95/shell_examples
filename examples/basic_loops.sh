#!/bin/sh

#source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/env.sh"


####################################################
# "for" loops                                      #
#                                                  #
# You provide a list of words and a variable name. #
# 'for' runs your loop body between 'do'...'done'  #
# with the named variable set each word in your    #
# list, one at a time.                             #
####################################################

####################################################
echo "/---------------------+"
echo "| 1. Simple Name Loop"
echo "+"
echo

for name in Alice Bob Carol Dave Eve
do
    echo "Hello, ${name}"
done

echo
####################################################
echo "/--------------------------------------------+"
echo "| 2. Loop over a set of files in a directory"
echo "+"
echo

# warning: this is not doing proper error checking; it might
#          fail if the given dir has no .png files, depending
#          on your shell settings.

# read a line of text from stdin into a variable
# (our stdin is unlikely to be redirected, so this
# will probably be - as intended - typed from the user)
echo "Enter a dir (full path) that contains .png files> "
read PNGDIR

if test -d "${PNGDIR}"
then
    # got a valid path to a dir
    echo "The .png files in \"${PNGDIR}\" (with sizes in bytes)"

    # note that the $ expansion of PNGDIR is quoted, which
    # handles spaces in paths properly, but the * is NOT quoted
    # (if it was quoted, it would be a literal *, not the
    # glob wildcard that matches any number of characters).
    #
    # You can selectively quote (or not quote) partial strins!
    # You can even mix-n-match quoting, e.g.:
    #  echo "has spaces"'!'" and "unquoted" bits and a dblquote-active char"
    for filepath in "${PNGDIR}"/*.png
    do
        filename="$(basename "${filepath}")"
        filesize="$(stat --format="%s" "${filepath}")"
        echo "    ${filename} ${filesize}"
    done
    echo "End of .png list"
else
    echo "Oops, \"${PNGDIR}\" is not a directory!"
fi


####################################################
echo
echo "/--------------------------------------------+"
echo "| 3. loop over filtered results"
echo "+"
echo

generate_numbers()
{
    seq 1 9
}

filter_small_primes() {
    grep -v '2\|3\|5\|7'
}

generate_composites()
{
    generate_numbers | filter_small_primes
}

for num in $(generate_composites)
do
    if test $num -eq 4 || test $num -eq 8
    then
        echo "$num is a cool power of 2!"
    else
        echo "$num is an ugly mix of factors other than 2"
    fi
done


