#!/bin/sh

if [ $# -ne 4 ]; then
    echo "Usage: $0 <type> <key> <value> <settings-xml-file> "
    exit 1
fi

xmlstarlet ed -P --inplace --update "/resources/$1[@name='$2']" -v "$3" "$4"
