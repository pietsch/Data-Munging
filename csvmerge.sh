#!/bin/bash

## author: Christian Pietsch <chr.pietsch+github at GoogleMail>
## date: 11 January 2012
## licence: GPLv3
## purpose: merge any number of identically structured CSV files into one

HEADER=the_header
OUTNAME="$(basename $PWD)_alle.csv"

if [ $# -lt 1 ]
then
    echo "Usage example: $(basename $0) *.csv"
    exit
fi

head -n 1 "$1" > "$HEADER"
for i in "$@"
do
    tail -n+2 "$i" > "$i.headerless"
done
cat "$HEADER" *.headerless > "$OUTNAME"

rm *.headerless
rm "$HEADER"

echo "Done. The output is in ${OUTNAME}."
