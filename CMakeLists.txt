##
#  CMake script for FE:
##

# Set the name of the project and target:
SET(TARGET "src/ceres")


# Declare all source files the target consists of. Here, this is only
# the one step-X.cc file, but as you expand your project you may wish
# to add other source files as well. If your project becomes much larger,
# you may want to either replace the following statement by something like

SET(GCC_COVERAGE_COMPILE_FLAGS "-larmadillo")
SET(GCC_COVERAGE_LINK_FLAGS    "-larmadillo")

SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}" )
SET( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}" )

add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})

FILE(GLOB_RECURSE TARGET_SRC  "support_code/*.cpp")
FILE(GLOB_RECURSE TARGET_INC  "support_code/*.h")
SET(TARGET_SRC ${TARGET_SRC}  ${TARGET_INC}) 

add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})


# or switch altogether to the large project CMakeLists.txt file discussed
# in the "CMake in user projects" page accessible from the "User info"
# page of the documentation.

SET(TARGET_SRC
  ${TARGET}.cc
  )

# Usually, you will not need to modify anything beyond this point...

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.8)

FIND_PACKAGE(deal.II 8.2 QUIET
  HINTS ${deal.II_DIR} ${DEAL_II_DIR} ../ ../../ $ENV{DEAL_II_DIR}
  )
IF(NOT ${deal.II_FOUND})
  MESSAGE(FATAL_ERROR "\n"
    "*** Could not locate a (sufficiently recent) version of deal.II. ***\n\n"
    "You may want to either pass a flag -DDEAL_II_DIR=/path/to/deal.II to cmake\n"
    "or set an environment variable \"DEAL_II_DIR\" that contains this path."
    )
ENDIF()

add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})


DEAL_II_INITIALIZE_CACHED_VARIABLES()

add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})

PROJECT(${TARGET})
add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})


DEAL_II_INVOKE_AUTOPILOT()

add_definitions(${GCC_COVERAGE_COMPILE_FLAGS})

