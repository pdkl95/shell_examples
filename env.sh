#!/bin/bash

###  Trap direct-running, as it's useless
if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
cat <<EOF
Running $(basename $0) directly will not do anything. This file is
intended to be "sourced" by other bash scripts in this project,
to setup the common project environment.

For example, scripts in the child dirs examples/ and templates/
should load the project env at the start of their script with
something like this (adjust the number of nestedf dirnames as needed):

    source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/env.sh"

EOF

    exit 1
fi


##########################################################################
# Project Directories

SHELL_EXAMPLES_ROOT="$(dirname "${BASH_SOURCE[0]}")"

DATADIR="${SHELL_EXAMPLES_ROOT}/data"
EXAMPLESDIR="${SHELL_EXAMPLES_ROOT}/examples"
TEMPLATESDIR="${SHELL_EXAMPLES_ROOT}/templates"


##########################################################################
# helper functions for less distracting boilerplate in examples

declare current_example_num=0
declare example_count=0
example() {
    # using 'test' instead of '[' or '[[' for maximum compatability
    # ("test ...args..." can probably be replaced with "[ ...args... ]")
    if test $# -eq 2
    then
        # if we were given two parameters, use the first to
        # (re-)initialze current_example_num.
        current_example_num=$1
        # removed $1 and continue as if we only
        # received a single parameter
        shift
    else
        # otherwise, autoincrement the current_example_num

        # Using /usr/bin/expr for greater compatablity;
        # using bash's builtin arithmetic evaluation is
        # probably a lot faster:
        #    current_example_num=$((current_example_num+1))
        current_example_num="$(expr ${current_example_num} + 1)"
    fi

    # first (and only) parameter is the example title
    local title="$1"

    if test $example_count -gt 0
    then
        # this is not the first example;
        # do any inter-example-only extra printing

        # extra newline to add whitespace between examples
        echo
        echo
    fi

    # prepend the example number to the title
    title="${current_example_num}. ${title}"

    ############################
    # print the example header #
    ############################

    # first, a bit of unnecesary work to make the
    # output look nicer...

    # Get a string of '-' the same length as the title.
    # 'tr' transliterates chars in the first arg to the
    # respective chars in the 2nd arg. Option '-c' changes
    # the first arg to the compliment set of chars. This means
    # "tr -c '-' '-' mesns "transliterate every char that
    # is NOT '-' into the char '-'"
    local title_as_dashes="$(echo -n "$title" | tr -c '-' '-')"

    # print the title itself in an unnecessarily-fancy box
    echo "/-${title_as_dashes}-+"
    echo "| ${title} |"
    echo "+-${title_as_dashes}-/"

    # add an blank line between the title box snd the example output
    echo


    # Finally, count how many examples were shown.
    # Using /usr/bin/expr for greater compatablity;
    # using bash's builtin arithmetic evaluation is
    # probably a lot faster:
    #    example_count=$((example_count+1))
    example_count="$(expr ${example_count} + 1)"
}

end_of_examples() {
    if test "$example_count" -eq 0
    then
        echo "Did someone forget to write the actual examples?"
    else
        echo
        echo "--"
        echo "Sucessfully displayed ${example_count} examples!"
    fi
}
