function(add_litex_firmware _target)
    cmake_parse_arguments(add_litex_firmware_args "NO_AUTO_LINK;NO_LITEX_INCLUDE" "" "" ${ARGN})
    add_executable(${_target} ${CPU_DIRECTORY}/crt0freertos.S ${add_litex_firmware_args_UNPARSED_ARGUMENTS})

    if(NOT add_litex_firmware_args_NO_LITEX_INCLUDE)
        target_include_directories(${_target} PUBLIC ${LITEX_INCLUDE_DIRS} ${PACKAGE_DIRS})
        target_link_directories(${_target} PUBLIC ${LITEX_PACKAGES_LIBRARY_DIRS})
        target_link_libraries(${_target} ${LITEX_LIBRARIES})
    endif()

    target_link_options(${_target} PUBLIC
            -T${DEFAULT_LINK_SCRIPT} -Wl,--whole-archive -Wl,--gc-sections
            )
    set_target_properties(${_target} PROPERTIES LINK_DEPENDS ${DEFAULT_LINK_SCRIPT})

    # Generates the binary with objcopy.
    add_custom_command(
            OUTPUT "${_target}.bin"
            DEPENDS ${_target}
            COMMENT "objcopy -O binary ${_target} ${_target}.bin"
            COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${_target} "${_target}.bin"
    )

    # Bind above objcopy custom command with `minimal_bin` target.
    add_custom_target("${_target}_bin" DEPENDS ${_target}.bin)

    if (NOT TARGET litex_all)
        add_custom_target(litex_all ALL)
    endif()

    add_dependencies(litex_all "${_target}_bin")
endfunction()