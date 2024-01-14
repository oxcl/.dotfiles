cmake_minimum_required(VERSION ${1:`(shell-command-to-string "cmake --version | grep -oP '\b\d*\.\d*' | head -n1")`})
`(let ((description "this auto-insert generates a basic boilerplate for cmake with the current installed version as minimum required version and the parent directory name as project name.")))`
