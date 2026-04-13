#!/bin/bash
###############################################################################
# Copyright (c) 2014-2025 libbitcoin developers (see COPYING).
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
    if [[ $# -eq 0 ]]; then
        display_usage
        exit 1
    fi

    CONFIGURATION=$1
    shift

    # Do everything relative to this file location.
    BUILD_PATH=`dirname "$0"`
    push_directory ${BUILD_PATH}

    msg "Generating for configuration ${CONFIGURATION}..."

    # Generate process scripts (explict enumeration).
    msg_warn "${GSL} -script:process/generate_artifacts.sh.gsl ${CONFIGURATION}"
    eval ${GSL} -script:process/generate_artifacts.sh.gsl ${CONFIGURATION}
    msg_warn "${GSL} -script:process/copy_statics.sh.gsl ${CONFIGURATION}"
    eval ${GSL} -script:process/copy_statics.sh.gsl ${CONFIGURATION}
    msg_warn "${GSL} -script:process/copy_projects.sh.gsl ${CONFIGURATION}"
    eval ${GSL} -script:process/copy_projects.sh.gsl ${CONFIGURATION}

    # Make process scripts executable.
    msg_verbose "Modifying properties of shell scripts."
    eval chmod +x process/*.sh

    # Execute process scripts (explicit enumeration).
    msg_warn "Generating artifacts for configuration ${CONFIGURATION}..."
    eval ./process/generate_artifacts.sh
    push_directory process
    eval ./copy_statics.sh "$@"
    eval ./copy_projects.sh "$@"
    pop_directory
    pop_directory
    msg_success "Generation for configuration ${CONFIGURATION} completed successfully."
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

display_usage()
{
    msg "Usage: ${BASH_SOURCE[0]##*/} configuration [targets...]"
    msg ""
    msg "   configuration      required xml file"
    msg "   targets            all targets to be copied"
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
