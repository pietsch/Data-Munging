#!/bin/bash

## purpose: convert ONIX XML as used by the mEDRA DOI registration agency into DataCite XML
## author: Christian Pietsch <cpietsch @ uni-bielefeld>
## date: 2016-06-29
## license: CC BY 4.0

DATACITE_USER="TIB.UNIBI"
test -f .datacite_password || (echo "Please create a text file called .datacite_password containing just your password."; exit 1)
DATACITE_PASSWORD=$(<.datacite_password)
ONIX_INPUT="metadata_doi_prefix_*_monograph.xml"  ## make sure this is exactly one file

## Throw away the name space declaration because it is evil:
sed -i 's# xmlns="http://www.editeur.org/onix/DOIMetadata/1.0"##' "$ONIX_INPUT"

## We want one file per title:
csplit --silent --elide-empty-files --digits=6 --prefix=metadata_monograph_number_ "$ONIX_INPUT" '/\<DOIMonographicProduct\>/+1' '{*}'

## BEGIN work around csplit's superfluous first split
TMPFILE=$(mktemp)
cat metadata_monograph_number_000000 metadata_monograph_number_000001 > "$TMPFILE"
mv "$TMPFILE" metadata_monograph_number_000001
rm metadata_monograph_number_000000
## END work around csplit's superfluous first split

for input in metadata_monograph_number_*
do
    xsltproc medra_onix_monograph2datacite3.1.xsl "$input" > "datacite_${input}.xml"
done
