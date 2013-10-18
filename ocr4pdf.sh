#!/bin/bash

## purpose: This script uses Tesseract to perform OCR on a given PDF
##          file.  The result is stored in one big PDF file called
##          like the source file with "ocr-" prepended.
##
## requirements: GNU/Linux, Tesseract 3.x, hocr2pdf (from the
##          exactimage package), Ghostscript, pdftk
##
## author:  Christian Pietsch <http://purl.org/net/pietsch>, 2013-10-18

if [ $# != 2 ]
then
  echo "Usage: $(basename $0) LANG INPUT"
  echo
  echo "Where LANG is the language (and script) of your document,"
  echo "e.g. deu-frak for German in blackletter script or eng for English,"
  echo "and INPUT is the name of your input PDF file."
  echo "The ouput will be stored in a file called like ocr-INPUT."
  tesseract --list-langs 2>&1 | tr '\n' ' '
  echo; echo
  exit -1
fi

OLDWD="$PWD"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT TERM INT
cd "$TMPDIR"

## explode input PDF file into one PDF file for each page:
pdftk "${OLDWD}/$2" burst output "pg-${2}-%d.pdf"

for i in pg-*.pdf
do 
  gs -q -dNOPAUSE -sDEVICE=tiffgray -r300x300 -sOutputFile="${i%%.pdf}.tiff" -- "$i"
done

## optionally ToDo: convert TIFF to PNM, process with unpaper, then convert back

find . -iname "*.tif" -o -iname "*.tiff" | while read infile
do
  file=$(echo $infile | cut -b 1-2 --complement)
  tesseract -l $1 "$file" "ocr-${file}" hocr
  hocr2pdf -i "${file}" -o "ocr-${file}.pdf" < "ocr-${file}.html" 
done

## make one big PDF file with all pages
pdftk ocr-pg-${2}-*.tiff.pdf cat output "${OLDWD}/ocr-${2}"
