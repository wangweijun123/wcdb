#!/bin/bash

root=`git rev-parse --show-toplevel`

paths=(common repair objc swift tools/templates tools/version)
codeFormatter=$root/tools/formatting/format_code.sh

error=false
for path in ${paths[@]}; do
    fullpath=$root/$path
    for file in `find $fullpath \( -name "*.h" -or -name "*.hpp" -or -name "*.c" -or -name "*.cpp" -or -name "*.m" -or -name "*.mm" -or -name "*.swift" \)`; do
        if ! (sh $codeFormatter --noadd $file); then
            exit 1
        fi
    done
done
