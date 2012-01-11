Data Munging
============


csvmerge.sh
-----------

Empirical researchers keep coming to me for help with merging large numbers of
identically structured data tables (usually with .csv or .dat extensions) into
one. This does not seem to be easy with SPSS or similar statistics software. If
you know how to use GNU command line tools, this is a trivial task:
**Glue all the files together, keeping only the first header intact.**
This is what this little shell script does. Tested on Linux and Mac OS X. On
Windows, you will need to install some additional software such as CygWin,
MinGW or UWIN.

Warning: All input files must have exactly one header line.


* * * * *
*Christian Pietsch*
