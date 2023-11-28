cmake_minimum_required(VERSION 3.23)

# Configure some high-level compiler options & settings
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_COLOR_MAKEFILE ON)
set(CMAKE_COLOR_DIAGNOSTICS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_VERBOSE_MAKEFILE ON CACHE STRING "Toggle verbose Makefiles")
set(CMAKE_BUILD_TYPE Debug CACHE STRING "Set the build type (default: debug)")

# =============================================================================
# Core project definition
# =============================================================================
project(FFMalloc
    VERSION
        1.0
    DESCRIPTION
        "Modified version of FFMalloc one-time allocator"
    LANGUAGES
        C CXX
)

# Load GNU install directory namings (e.g. /usr/local/bin, /usr/local/lib, etc.)
include(GNUInstallDirs)

message(STATUS "FFMalloc build configuration:
\tTarget project: ${PROJECT_NAME}
\tRoot directory:  ${FFMalloc_SOURCE_DIR}")

# =============================================================================
# KrmlLib definition
# =============================================================================
add_library(FFMalloc SHARED)

set_target_properties(FFMalloc
    PROPERTIES
        C_STANDARD 23
        CXX_STANDARD 23
        C_EXTENSIONS ON
        CXX_EXTENSIONS ON
        C_STANDARD_REQUIRED ON
        CXX_STANDARD_REQUIRED ON
)

# Specify include file tree (publicly available)
target_include_directories(FFMalloc PUBLIC "${FFMalloc_SOURCE_DIR}/src")

# Define the sources for the analysis library
target_sources(FFMalloc
    PRIVATE "${FFMalloc_SOURCE_DIR}/src/ffmalloc.c"
    PUBLIC
        FILE_SET HEADERS
        BASE_DIRS "${FFMalloc_SOURCE_DIR}/src"
        FILES "${FFMalloc_SOURCE_DIR}/src/ffmalloc.h"
)

# Specify target-specific compile options
target_compile_definitions(FFMalloc
    PRIVATE
        -DFF_GROWLARGEREALLOC
        -D_GNU_SOURCE
        -DUSE_FF_PREFIX
        -DFFSINGLE_THREADED
)

target_compile_definitions(FFMalloc PUBLIC "_BSD_SOURCE" "_DEFAULT_SOURCE")
target_compile_options(FFMalloc PUBLIC -g -O3 -flto -fwrapv)
target_compile_options(FFMalloc PRIVATE -Wall -Wextra -Wpedantic)
target_compile_options(FFMalloc PUBLIC
    $<IF:$<C_COMPILER_ID:GNU>,-fdiagnostics-color=always,$<$<C_COMPILER_ID:Clang>:-fcolor-diagnostics>>
)

# Get and install into default installation dirs. Don't export headers, only compiled libs
install(
    TARGETS FFMalloc
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
