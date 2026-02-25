###############################################################################
#  Copyright (c) 2014-2026 libbitcoin developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################

function(remove_in_target_property target property value)
    if(NOT TARGET "${target}")
        message(WARNING "remove_in_target_property: Target '${target}' does not exist")
        return()
    endif()

    get_target_property(current "${target}" "${property}")

   if(NOT current)
        return()
    endif()

    list(FIND current "${old_value}" idx)
    if(idx EQUAL -1)
        return()
    endif()

    list(REMOVE_AT current ${idx})

    set_property(TARGET "${target}" PROPERTY "${property}" ${current})
endfunction()

function(replace_in_target_property target property old_value new_value)
    if(NOT TARGET "${target}")
        message(WARNING "replace_in_target_property: Target '${target}' does not exist")
        return()
    endif()

    get_target_property(current "${target}" "${property}")

    if(NOT current)
        return()
    endif()

    list(FIND current "${old_value}" idx)
    if(idx EQUAL -1)
        return()
    endif()

    list(REMOVE_AT current ${idx})

    if(NOT "${new_value}" STREQUAL "")
        list(INSERT current ${idx} "${new_value}")
    endif()

    set_property(TARGET "${target}" PROPERTY "${property}" ${current})
endfunction()

