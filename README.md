Data Munging
============


csvmerge.sh
-----------

Empirical researchers keep coming to me for help with merging large numbers of
identically structured data tables (usually with `.csv` or `.dat` extensions) into
one. This does not seem to be easy with SPSS or similar statistics software. If
you know how to use GNU command line tools, this is a trivial task:
**Glue all the files together, keeping only the first header intact.**
This is what this little shell script does. Tested on Linux and Mac OS X. On
Windows, you will need to install some additional software such as CygWin,
MinGW or UWIN.

Warning: All input files must have exactly one header line.


dd_mirror.sh
------------

This little script writes a clone of `/dev/sda` onto the next hard disk with
identical partition layout (assuming to have found a previous backup).

I wrote this script because when cloning a drive using the `dd` tool, it is easy
to mistype the destination drive and destroy all data on it. This script
assumes that you have mounted a drive containing a previous full disk backup
created independently, perhaps using a command like this: `dd if=/dev/sda of=/dev/sdX`.
Currently this script does not take any arguments. You need to specify the
source drive in the source code if it is not `/dev/sda`.

In order to speed things up, the script invokes two instances of `dd` connected
by a pipe.


pdf-cryptcheck.sh
-----------------

This is a little test script which uses pdfinfo from the poppler-tools
or xpdf-tools package to determine if a given PDF file is encrypted.
If so, it returns a non-zero exit status. Usage example for a
Bourne-like shell:

`if pdf-cryptcheck.sh example.pdf; then echo OK; else echo DRM; fi`


repair_ahf_data.sh
------------------

This script will not be very useful as it is (unless you receive bibliographic
data in a peculiar CSV-like format from AHF Munich). Perhaps it can serve as an
example on how to embed AWK and R code into a BASH script, and how to export
data files from R in a format that is readable by Excel (and of course
OpenOffice/LibreOffice and the excellent Gnumeric).


ocr4pdf.sh
----------

This script uses Tesseract to perform OCR on a given PDF file. Then
hocr2pdf is used to embed the result in a new PDF file called like the
source file with "ocr-" prepended.


medra_onix2datacite/
--------------------

An XSLT stylesheet for converting ONIX XML to DataCite XML. May it help you
migrate from mEDRA to DataCite.


* * * * *
*Christian Pietsch*

