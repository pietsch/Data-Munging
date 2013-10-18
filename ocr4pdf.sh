#!/bin/bash

## purpose: This script uses Tesseract to perform OCR on a given PDF
##          file.  The result is stored in one big PDF file called
##          like the source file with "ocr-" prepended.
##
## author:  Christian Pietsch <http://purl.org/net/pietsch>
##
## requirements: GNU/Linux, Tesseract 3.x, hocr2pdf (from the
##          exactimage package), Ghostscript, pdftk
##
## usage:   Put all PDF files you want to OCR into a one directory.
##          Then enter this directory and call this script.

if [ $# != 2 ]
then
  echo "Usage: $(basename $0) LANG INPUT"
  echo -n "Where LANG is the language (and script) of your documents, "
  echo "e.g. deu-frak for German in blackletter script."
  tesseract --list-langs 2>&1 | tr '\n' ' '
  echo
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
