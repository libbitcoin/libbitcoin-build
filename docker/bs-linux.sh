#!/bin/bash

set -e

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
    display_message "Usage: ./bs-linux.sh [OPTION]..."
    display_message "Manage the generation of a docker image of bitcoin-server (bs)."
    display_message "Script options:"
    display_message "  --build-dir=<value>  Directory for building docker image"
    display_message "  --source=<value>     xml file for gsl generation."
    display_message "  --tag=<value>        git tag to utilize with source instructions."
    display_message ""
}

fatal_error()
{
    display_error "$@"
    display_error ""
    display_help
    exit 1
}

display_state()
{
    display_message "Parameters:"
    display_message "  DIR_BUILD        : ${DIR_BUILD}"
    display_message "  SOURCE           : ${SOURCE}"
    display_message "  TAG              : ${TAG}"
    display_message "Deduced:"
    display_message "  DIR_BUILD_PROJ   : ${DIR_BUILD_PROJ}"
    display_message "  VERSION          : ${VERSION}"
}

dispatch_help()
{
    if [[ ${DISPLAY_HELP} ]]; then
        display_help
        exit 0
    fi
}

initialize_environment()
{
    # https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
    local DIR_SCRIPT=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    # initialize DIR_BUILD_PROJ
    pushd "${DIR_SCRIPT}/.."
    DIR_BUILD_PROJ="$(pwd)"
    popd

    if [ -f ${DIR_BUILD_PROJ}/${SOURCE} ]; then
        SOURCE_VERSION=$(grep '<repository' ${DIR_BUILD_PROJ}/${SOURCE} | \
            grep libbitcoin-server | \
            sed -n s/.*version=\"//p | \
            sed -n s/\".*//p)
    else
        fatal_error "  --source=<value> must be a valid filename in the expected path."
    fi

    # rationalize intended version
    if [ -z ${TAG} ]; then
        VERSION="${SOURCE_VERSION}"
    else
        if [[ "${TAG}" =~ ^v.* ]]; then
            VERSION=$(echo "${TAG}" | sed -n s/v//p)
        else
            VERSION="${TAG}"
        fi
    fi

    # cleanup build directory
    if [ -d ${DIR_BUILD} ]; then
        display_message "Directory '${DIR_BUILD}' found, emptying..."
        pushd ${DIR_BUILD}
        rm -rf Dockerfile developer_setup.sh src/
        mkdir -p "${DIR_BUILD}/src"
        popd
    else
        display_message "Directory '${DIR_BUILD}' not found, building..."
        mkdir -p "${DIR_BUILD}/src"
    fi
}

validate_parameterization()
{
    if [ -z ${DIR_BUILD} ]; then
        fatal_error "  --build-dir=<value> required."
    fi

    if [ -z ${SOURCE} ]; then
        fatal_error "  --source=<value> required."
    fi
}

parse_command_line_options()
{
    for OPTION in "$@"; do
        case ${OPTION} in
            # Specific
            (--build-dir=*) DIR_BUILD="${OPTION#*=}";;
            (--source=*)    SOURCE="${OPTION#*=}";;
            (--tag=*)       TAG="${OPTION#*=}";;

            # Standard
            (--help)        DISPLAY_HELP="yes";;
        esac
    done
}

generate_instructions()
{
    display_message "Generate developer_setup.sh..."

    # create developer_setup.sh
    pushd ${DIR_BUILD_PROJ}
    eval gsl -q -script:templates/gsl.developer_setup.sh ${SOURCE}
    chmod +x output/libbitcoin-*/developer_setup.sh
    popd
}

initialize_build_directory()
{
    display_message "Initialize build directory contents..."
    cp ${DIR_BUILD_PROJ}/output/libbitcoin-server/developer_setup.sh ${DIR_BUILD}

    pushd ${DIR_BUILD}

    local BUILD_TAG_PARAM=""
    if [ -z ${TAG} ]; then
        BUILD_TAG_PARAM=""
    else
        BUILD_TAG_PARAM="--build-tag=${TAG}"
    fi

    ./developer_setup.sh ${BUILD_TAG_PARAM} \
        --build-sync-only \
        --build-src-dir="${DIR_BUILD}/src" \
        --build-target=all

    popd
}

dockerize()
{
    pushd ${DIR_BUILD}
    display_message "----------------------------------------------------------------------"
    display_message "docker build           : libbitcoin/bitcoin-server:${VERSION}"
    display_message "----------------------------------------------------------------------"
    docker build -t libbitcoin/bitcoin-server:${VERSION} -f ${DIR_BUILD_PROJ}/docker/bs-linux.Dockerfile .
    popd
}

parse_command_line_options "$@"
dispatch_help
validate_parameterization
initialize_environment
display_state
generate_instructions
initialize_build_directory
dockerize
