# All variables starting with TEMPLATE will be substituted during toolchain generation.

include(${TEMPLATE_PATH}/cmake_functions.cmake)

### SETTINGS ####
set(CCACHE_PREFIX "")
#################

### GENERATED VARIABLES ###
${TEMPLATE_VARIABLES}
###########################

### ADDITIONAL VARIABLES ###
set(LITEX_INCLUDE_DIRS
    ${PICOLIBC_DIRECTORY}/newlib/libc/tinystdio
    ${PICOLIBC_DIRECTORY}/newlib/libc/include
    ${LIBBASE_DIRECTORY}
    ${SOC_DIRECTORY}/software/include
    ${SOC_DIRECTORY}/software
    ${BUILDINC_DIRECTORY}
    ${BUILDINC_DIRECTORY}/../libc
    ${CPU_DIRECTORY})

set(LITEX_TARGET_PREFIX "${TRIPLE}-")
#################

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ${CPUFAMILY})

# TC_PATH can be changed on command line.
if (NOT DEFINED TC_PATH)
    set(TC_PATH "")
    message(STATUS "No -DTC_PATH specified, assuming toolchain is available on PATH.")
endif ()

# Binaries
set(COMPILER_PREFIX "${CCACHE_PREFIX}${TC_PATH}${LITEX_TARGET_PREFIX}")
set(CMAKE_C_COMPILER "${COMPILER_PREFIX}gcc${TC_EXT}" CACHE INTERNAL "C Compiler")
set(CMAKE_C_COMPILER "${COMPILER_PREFIX}gcc${TC_EXT}" CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER "${COMPILER_PREFIX}g++${TC_EXT}" CACHE INTERNAL "C++ Compiler")
set(CMAKE_AR "${TC_PATH}${LITEX_TARGET_PREFIX}gcc-ar" CACHE INTERNAL "Archive tool")
set(CMAKE_LINKER "${TC_PATH}${LITEX_TARGET_PREFIX}ld${TC_EXT}" CACHE INTERNAL "Linker Binary")
set(CMAKE_OBJCOPY "${TC_PATH}${LITEX_TARGET_PREFIX}objcopy${TC_EXT}" CACHE INTERNAL "Objcopy Binary")

# Standard options
set(DEPFLAGS "-MD -MP")
set(COMMON_FLAGS "${DEPFLAGS} ${CPUFLAGS} -Os -g3 -fomit-frame-pointer -Wall -fno-builtin -fstack-protector-strong -flto")
set(CMAKE_C_FLAGS "${COMMON_FLAGS} -std=gnu99 -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -fno-exceptions -fno-rtti -ffreestanding -fno-use-cxa-atexit" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -nodefaultlibs  -Wl,--whole-archive -Wl,--gc-sections -Wl,--no-dynamic-linker -Wl,--build-id=none -Wl,-Map=${CMAKE_PROJECT_NAME}.map ${CMAKE_C_FLAGS} -L${BUILDINC_DIRECTORY}" CACHE INTERNAL "Linker options")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE INTERNAL "ASM Compiler options")

set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> crs <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> crs <TARGET> <LINK_FLAGS> <OBJECTS>")
# Don't call ranlib on the archives.
set(CMAKE_CXX_ARCHIVE_FINISH "")
set(CMAKE_C_ARCHIVE_FINISH "")

# TODO: Move optimization flags to respective part.
# TODO: Move warning/error flags to separate variable. (treat all errors as warnings)

set(COMMON_RELEASE_FLAGS "-flto")

# Debug flags
set(CMAKE_ASM_FLAGS_DEBUG "" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_C_FLAGS_DEBUG "" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Release flags
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_C_FLAGS_RELEASE "${COMMON_RELEASE_FLAGS}" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "${COMMON_RELEASE_FLAGS}" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "" CACHE INTERNAL "Linker options for release build type")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)