#!/bin/bash

## purpose: register a DOI with DataCite given metadata as DataCite XML and URL in files
## author: Christian Pietsch <cpietsch @ uni-bielefeld>
## date: 2016-07-01
## license: CC BY 4.0

DATACITE_USER="TIB.UNIBI"
test -f .datacite_password || (echo "Please create a text file called .datacite_password containing just your password."; exit 1)
DATACITE_PASSWORD=$(<.datacite_password)

## validate the XML files just generated against the XML Schema for DataCite Metadata Kernel 3.1: 
wget -nc http://schema.datacite.org/meta/kernel-3.1/metadata.xsd
test -d include || mkdir include
cd include && wget -q -nc http://schema.datacite.org/meta/kernel-3.1/include/datacite-descriptionType-v3.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-relatedIdentifierType-v3.1.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-relationType-v3.1.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-resourceType-v3.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-dateType-v3.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-contributorType-v3.1.xsd http://schema.datacite.org/meta/kernel-3.1/include/datacite-titleType-v3.xsd && cd ..
xmllint --noout --schema metadata.xsd *.xml && echo "--> All files are valid." || (echo "--> Not all files are valid."; exit 2)

## prepare for re-registering the DOIs with DataCite
for input in *.xml
do
    URL=$(<${input%.xml}.url)
    URL=${URL//[$'\r\n']}  ## chomp (remove trailing line endings, if present)
    DOI=$(xsltproc extract_doi_from_datacite.xsl ${input})
    LOG="/var/tmp/datacite_upload.log"
    #TESTMODE="?testMode=true"
    curl -u "${DATACITE_USER}:${DATACITE_PASSWORD}" -H "Content-Type: application/xml" --data-binary @${input} https://mds.datacite.org/metadata$TESTMODE 2>&1 >>"$LOG"
    echo >>"$LOG"
    curl -u "${DATACITE_USER}:${DATACITE_PASSWORD}" -d "url=$URL" -d "doi=$DOI" https://mds.datacite.org/doi$TESTMODE 2>&1 >>"$LOG"
    echo >>"$LOG"
done
