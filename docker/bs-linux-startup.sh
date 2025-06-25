#!/bin/bash

set -ex

SCRIPT_IDENTITY=$(basename "$0")

display_message()
{
    printf "%s\n" "$@"
}

display_error()
{
    >&2 printf "%s\n" "$@"
}

display_help()
{
    display_message "Usage: ./${SCRIPT_IDENTITY} [OPTION]..."
    display_message "Docker instance startup script."
    display_message "Script options:"
    display_message "  --unconditional-init Force database reset."
    display_message ""
}

fatal_error()
{
    display_error "$@"
    display_error ""
    display_help
    exit 1
}

dispatch_help()
{
    if [[ ${DISPLAY_HELP} ]]; then
        display_help
        exit 0
    fi
}

parse_command_line_options()
{
    for OPTION in "$@"; do
        case ${OPTION} in
            # Specific
            (--unconditional-init)  INIT_UNCONDITIONAL="yes";;

            # Standard
            (--help|-h)             DISPLAY_HELP="yes";;
        esac
    done
}

initialize()
{
    if [[ -z "$( ls -A blockchain )" ]]; then
        ./bs -c conf/bs.cfg --initchain
    elif [[ $INIT_UNCONDITIONAL ]]; then
        ./bs -c conf/bs.cfg --initchain
    fi
}

execute_service()
{
    ./bs -c conf/bs.cfg
}

parse_command_line_options "$@"
dispatch_help
initialize
execute_service
