include(CMakePrintHelpers)

cmake_minimum_required(VERSION 3.20.0)
project(Compiladores)

# set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR})

file(GLOB src_files ${PROJECT_SOURCE_DIR}/src/*)

cmake_print_variables(src_files)
# cmake_print_variables(INCLUDE_DIRECTORIES)

add_executable(a ${src_files})

# Configuração do Flex
# cmake_policy(SET CMP0098 NEW)
find_package(FLEX)
FLEX_TARGET(MyScanner ${CMAKE_CURRENT_SOURCE_DIR}/src/lexico.l ${CMAKE_CURRENT_BINARY_DIR}/lexico.yy.cc COMPILE_FLAGS "-+")
# FLEX_TARGET(MyScanner ${CMAKE_CURRENT_SOURCE_DIR}/src/lexico.l)

# target_sources(MyScanner PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
# include_directories(${CMAKE_CURRENT_BINARY_DIR})
# target_include_directories(a PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

target_sources(a PRIVATE ${FLEX_MyScanner_OUTPUTS})
target_include_directories(a PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
# get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
# foreach(dir ${dirs})
#   message(STATUS "dir='${dir}'")
# endforeach()
