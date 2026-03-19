###############################################################################
#  Copyright (c) 2014-2026 libbitcoin developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################

function(print_target_link_libraries tgt)
    if(NOT TARGET ${tgt})
        message(WARNING "print_target_link_libraries: ${tgt} is not a target")
        return()
    endif()

    include(CMakePrintHelpers)

    message(STATUS "")
    message(STATUS "Link information for target: ${tgt}")
    message(STATUS "----------------------------------------")

    cmake_print_properties(
        TARGETS ${tgt}
        PROPERTIES
            LINK_LIBRARIES
            INTERFACE_LINK_LIBRARIES
            LINK_OPTIONS
            INTERFACE_LINK_OPTIONS
    )

    get_target_property(libs ${tgt} LINK_LIBRARIES)
    if(libs)
        message(STATUS "Direct libraries:")
        foreach(lib IN LISTS libs)
            message(STATUS "  ${lib}")
        endforeach()
    endif()

    # Optional: try to resolve to final linker-style names (approxi:qmate)
    message(STATUS "Final link line approximation (not exact):")
    foreach(lib IN LISTS libs)
        if(TARGET ${lib})
            # It's a CMake target → would be resolved transitively
            message(STATUS "  <target ${lib}>")
        elseif(IS_ABSOLUTE "${lib}")
            # Full path
            message(STATUS "  ${lib}")
        elseif(lib MATCHES "^-.+")
            # Flag
            message(STATUS "  ${lib}")
        else()
            # -lxxx style
            message(STATUS "  -l${lib}")
        endif()
    endforeach()
endfunction()
