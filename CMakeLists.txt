cmake_minimum_required(VERSION 3.16.3)
project(FFMalloc)

# =============================================================================
# Global CMake core & compiler settings
# =============================================================================
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
set(LOG_LVL LVL_INFO CACHE STRING "Logging level for VeriPatch")
set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type debug" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)

# =============================================================================
# KrmlLib definition
# =============================================================================
add_library(FFMalloc SHARED)
target_sources(FFMalloc
    PUBLIC
        src/ffmalloc.h
    PRIVATE
        src/ffmalloc.c
)

# Specify target-specific compile options
target_compile_definitions(FFMalloc
    PRIVATE
        -DFF_GROWLARGEREALLOC
        -D_GNU_SOURCE
        -DUSE_FF_PREFIX
        -DFFSINGLE_THREADED
)
target_compile_options(FFMalloc
    PRIVATE
        -c
        -g
        -O2
        -fPIC
        -Wall
        -Wextra
        -Wno-reorder
        -D_GNU_SOURCE
        -Wno-unknown-pragmas
        -DFF_GROWLARGEREALLOC
        -Wno-unused-parameter
        -Wno-overloaded-virtual
        -Wno-ignored-qualifiers
        -fdiagnostics-color=always
)
target_link_options(FFMalloc PRIVATE -fuse-ld=lld)
target_compile_definitions(FFMalloc PRIVATE LOG_LVL=${LOG_LVL})
target_compile_features(FFMalloc
    PRIVATE
        cxx_std_20
        c_std_11
)

# Specify include file tree (publicly available)
target_include_directories(FFMalloc PUBLIC ${CMAKE_CURRENT_LIST_DIR}/src)

# Get and install into default installation dirs. Don't export headers, only compiled libs
include(GNUInstallDirs)
install(
    TARGETS
        FFMalloc
    RUNTIME
        DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
