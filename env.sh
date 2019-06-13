#!/bin/bash

###  Trap direct-running, as it's useless
if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
cat <<EOF
Running $(basename $0) directly will not do anything. This file is
intended to be "sourced" by other bash scripts in this project,
to setup the common project environment.

For exsmple, scripts in the child dirs examples/ and templates/
should load the project env at the start of their script with
something like this (adjust the number of nestedf dirnames as needed):

    source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/env.sh"

EOF

    exit 1
fi

SHELL_EXAMPLES_ROOT="$(dirname "${BASH_SOURCE[0]}")"

DATADIR="${SHELL_EXAMPLES_ROOT}/data"
EXAMPLESDIR="${SHELL_EXAMPLES_ROOT}/examples"
TEMPLATESDIR="${SHELL_EXAMPLES_ROOT}/templates"

