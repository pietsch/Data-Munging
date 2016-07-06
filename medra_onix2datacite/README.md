# Tools for migrating DOIs from mEDRA to DataCite

## Purpose:

These code snippets may or may not facilitate your migration from a DOI
registration agency that uses ONIX XML (such as mEDRA) to the DataCite DOI
registry. The core code is in `medra_onix_monograph2datacite3.1.xsl`. This
stylesheet does not cover all aspects of ONIX. In particular, it covers only
one publication type: monograph. (We used OJS to convert metadata for other
publication types.)

## Prerequisites:

Any XSLT 1.0 processor.

The included bash files just serve as an example. They use `xsltproc`.
`xmlstarlet` is only used by `look_up_url_for_doi.sh` which I've thown in as a
goodie.

## Files:

* `extract_doi_from_datacite.xsl` – nomen est omen
* `extract_doi_from_medra_onix.xsl` – nomen est omen
* `extract_target_url_from_medra_onix.xsl` – nomen est omen
* `find_correct_datacite_metadata_for_unregistered_doi.sh` – You hopefully won't need this. It re-registers discarded DOIs that had to be re-registered anyway so that the migration could take place.
* `look_up_url_for_doi.sh` – nomen est omen
* `medra_onix2datacite_xml.sh` – Does some preprocessing on the ONIX file we received from mEDRA/MVB-online.de and then applies the XSLT stylesheet `medra_onix_monograph2datacite3.1.xsl`.
* `medra_onix_monograph2datacite3.1.xsl` – This is the XSLT stylesheet that converts the ONIX XML format used by mEDRA into the XML format required by DataCite when registering DOIs with them
* `register_datacite_doi.sh` – Uploads the converted metadata to DataCite and re-mint the DOIs there.

## Author:

Christian Pietsch, 2016

## License:

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
