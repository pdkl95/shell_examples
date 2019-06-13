#!/bin/sh

VERSION="1.0"
AUTHOR="John Doe"
COPYRIGHT_YEAR="2000"

SCRIPT_NAME="getopt_example"
# or maybe SCRIPT_NAME="$(basename "$0")"

show_usage() {
cat <<EOF
Usage: ${SCRIPT_NAME} [options] <file> [...]
An example script that demonstrates the use of getopt.

OPTIONS
  -f, --feature      Enable special feature
  -n, --name=NAME    Set the name used in the special feature

  -h, --help         Show this help
  -V, --version      Show the script version
EOF
}

show_version() {
    echo "${SCRIPT_NAME} ${VERSION}"
    echo
    echo "Copyright (C) ${COPYRIGHT_YEAR} ${AUTHOR}
This program is free software; you may redistribute it under the terms
of the GNU General Public License. This program has absolutely no warranty."
}

##########################################################################
# OPTIONS

# globals w/ default values
name="example_default_name"
use_feature=false

if command -v getopt 2>&1 >/dev/null ; then
    # have GNU getopt (allows nicer options)
    SOPT="hVfn:"
    LOPT="help,verbose,feature,name:"
    OPTIONS=$(getopt -o "$SOPT" --long "$LOPT" -n "$SCRIPT_NAME" -- "$@") || exit 1
    eval set -- "$OPTIONS"
fi

while true ; do
    case "$1" in
        -h | --help)    show_usage       ;  exit 0 ;;
        -V | --version) show_verison     ;  exit 0 ;;
        -f | --feature) use_feature=true ; shift   ;;
        -n | --name)    name="$2"        ; shift 2 ;;
        --) shift ; break ;;
        -*) echo "unknown option: $1" ; exit 1 ;;
        *)  break ;;
    esac
done

##########################################################################
# MAIN

if [ "${#}" = 0 ] ; then
    show_usage
    exit 1
fi

for file in "$@" ; do
    if $use_feature ; then
        echo "Applying special feature to \"${file}\" (with name=\"${name}\")"
    else
        echo "Handling \"${file}\" without any special features"
    fi
done
