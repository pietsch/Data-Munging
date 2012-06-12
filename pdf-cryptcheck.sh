#!/bin/bash

## Author: Christian Pietsch
## Date: 2012-06-12
## Purpose: check a PDF file for presence of encryption
## Requirement: pdfinfo from the xpdf-tools or poppler-tools package
## Result: Returns 0 (true) if the PDF is unencrypted.
##         Other values (false) signal errors or the presence of encryption.

if [ $# -ne 1 ]; then
    echo "Usage: $0 FILENAME"
    exit 8
fi

enc_info=$(pdfinfo "$1" 2>&1 | grep ^Encrypted )
if [ "x$enc_info" == "x" ]; then
    exit 9
fi

unset LANG
echo "$enc_info" | grep " no$" >/dev/null
