cmake_minimum_required(VERSION 3.8)
project(${1:`(file-name-nondirectory (directory-file-name (file-name-directory buffer-file-name)))`})

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
endif()
`(let ((description "this auto-insert generates a basic boilerplate for cmake with the parent directory name as project name.")))`
