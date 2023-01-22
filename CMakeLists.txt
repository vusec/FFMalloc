cmake_minimum_required(VERSION 3.16.3)
project(FFMalloc C)

# =============================================================================
# Global CMake core & compiler settings
# =============================================================================
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
set(CMAKE_VERBOSE_MAKEFILE on CACHE STRING "Verbose Makefiles")
set(CMAKE_BUILD_TYPE Debug CACHE STRING "Debug Build Type" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(LOG_LEVEL "LOG_LEVEL_ERROR" CACHE STRING "Set the logging level")

# Global Compiler flags
add_compile_options("-Wall")
add_compile_options("-fdiagnostics-color=always")

# Set global linker options
add_link_options("-fuse-ld=lld")

# =============================================================================
# KrmlLib definition
# =============================================================================
add_library(FFMalloc SHARED)
target_sources(FFMalloc
    PUBLIC src/ffmalloc.h
    PRIVATE src/ffmalloc.c
)

# Specify target-specific compile options
target_compile_options(FFMalloc
    PRIVATE "-c"
    PRIVATE "-g"
    PRIVATE "-O3"
    PRIVATE "-fPIC"
    PRIVATE "-Wall"
    PRIVATE "-Wextra"
    PRIVATE "-Wno-reorder"
    PRIVATE "-D_GNU_SOURCE"
    PRIVATE "-Wno-unknown-pragmas"
    PRIVATE "-DFF_GROWLARGEREALLOC"
    PRIVATE "-Wno-unused-parameter"
    PRIVATE "-Wno-overloaded-virtual"
    PRIVATE "-Wno-ignored-qualifiers"
    PRIVATE "-fdiagnostics-color=always"
)

target_link_options(FFMalloc
    PRIVATE "-shared"
)

# Specify include file tree (publicly available)
target_include_directories(FFMalloc PUBLIC "src")

# Install LLVMUtils
install(TARGETS FFMalloc
    ARCHIVE RUNTIME LIBRARY PUBLIC_HEADER PRIVATE_HEADER
)
