#!/bin/bash

## Purpose: This script uses Tesseract to perform OCR on all PDF files
##          in the current directory (except for those whose base name
##          starts or ends with the string "ocr").  The result is
##          stored in one big PDF file called ocr-DIRECTORYNAME.pdf.
##          
## Author:  Christian Pietsch <http://purl.org/net/pietsch>
##
## Requirements: GNU/Linux, Tesseract 3.x, hocr2pdf (from the
##          exactimage package), Ghostscript, poppler-tools or pdftk
##
## Usage:   Put all PDF files you want to OCR into a one directory.
##          Then enter this directory and call this script.

if [ $# != 1 ]
then
  echo "Usage: $(basename $0) LANG"
  echo -n "Where LANG is the language (and script) of your documents, "
  echo "e.g. deu-frak for German in blackletter script."
  tesseract --list-langs 2>&1 | tr '\n' ' '
  echo
  exit -1
fi

for i in [^o][^c][^r][^-]*[^o][^c][^r].pdf 
do 
  gs -q -dNOPAUSE -sDEVICE=tiffgray -r300x300 -sOutputFile="${i%%.pdf}.tiff" -- "$i"
done

find . -iname "*.tif" -o -iname "*.tiff" | while read infile
do
  file=$(echo $infile | cut -b 1-2 --complement)
  tesseract -l $1 "$file" "ocr-${file}" hocr
  hocr2pdf -i "${file}" -o "ocr-${file}.pdf" < "ocr-${file}.html" 
done

## make one big PDF file with all pages
THISDIRNAME=$(basename $PWD)
COLLECTIONFILENAME="ocr-${THISDIRNAME}.pdf"
test -f ../"${COLLECTIONFILENAME}" && old ../"${COLLECTIONFILENAME}"
if type pdfunite >/dev/null 2>/dev/null
then
  pdfunite ocr-*.pdf "${COLLECTIONFILENAME}"
else
  pdftk ocr-*.pdf cat output "${COLLECTIONFILENAME}"
fi
