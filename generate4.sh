#!/bin/bash
###############################################################################
# Copyright (c) 2014-2026 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

OPTS_ENABLE="set -eo pipefail"
OPTS_DISABLE="set +e"

eval "${OPTS_ENABLE}"
trap 'msg_error "FATAL ERROR: Command failed at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

GSL="gsl -q"
COLOR_CYAN='\e[0;96m'
COLOR_GREEN='\e[0;92m'
COLOR_RED='\e[0;91m'
COLOR_YELLOW='\e[0;93m'
COLOR_RESET='\e[0m'

main()
{
    # Do everything relative to this file location.
    push_directory `dirname "$0"`

    # Clean directories for generated build artifacts.
    remove_directory_force "output"

    # Generate property copiers and artifact generators.
    msg_warn "${GSL} -script:gsl.copy_properties.sh generate4.xml"
    eval ${GSL} -script:gsl.copy_properties.sh generate4.xml
    msg_warn "${GSL} -script:gsl.generate_artifacts.sh generate4.xml"
    eval ${GSL} -script:gsl.generate_artifacts.sh generate4.xml

    # Make property copiers and artifact generators executable.
    msg_verbose "Modifying properties of shell scripts."
    eval chmod +x copy_properties.sh
    eval chmod +x generate_artifacts.sh

    # Execute property copiers and artifact generators.

    msg "Execute copy_properties.sh..."
    eval ./copy_properties.sh
    msg "Execute generate_artifacts.sh..."
    eval ./generate_artifacts.sh
    msg "Execute generate.sh..."
    eval ./generate.sh version4.xml
    msg "Execute copy_projects.sh..."
    eval ./copy_projects.sh "$@"

    pop_directory
    msg_success "Script execution completed successfully."
}

create_directory()
{
    local DIRECTORY="$1"
    local MODE="$2"

    if [[ -d "${DIRECTORY}" ]]; then
        if [[ ${MODE} == "-f" ]]; then
            msg_warn "Reinitializing '${DIRECTORY}'..."
            rm -rf "${DIRECTORY}"
            mkdir -p "${DIRECTORY}"
        else
            msg_warn "Reusing existing '${DIRECTORY}'..."
        fi
    else
        msg "Initializing '${DIRECTORY}'..."
        mkdir -p "${DIRECTORY}"
    fi
}

create_directory_force()
{
    create_directory "$@" -f
}

pop_directory()
{
    msg_verbose "*** move  pre: '$(pwd)'"
    popd >/dev/null
    msg_verbose "*** move post: '$(pwd)'"
}

push_directory()
{
    msg_verbose "*** move  pre: '$(pwd)'"
    local DIRECTORY="$1"
    pushd "${DIRECTORY}" >/dev/null
    msg_verbose "*** move post: '$(pwd)'"
}

remove_directory_force()
{
    msg_verbose "*** removing: '$@'"
    rm -rf "$@"
}

msg_heading()
{
    printf "\n********************** %b **********************\n" "$@"
}

msg_verbose()
{
    if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
        printf "${COLOR_CYAN}%b${COLOR_RESET}\n" "$@"
    fi
}

msg()
{
    printf "%b\n" "$@"
}

msg_success()
{
    printf "${COLOR_GREEN}%b${COLOR_RESET}\n" "$@"
}

msg_warn()
{
    printf "${COLOR_YELLOW}%b${COLOR_RESET}\n" "$@"
}

msg_error()
{
    >&2 printf "${COLOR_RED}%b${COLOR_RESET}\n" "$@"
}

main "$@"
