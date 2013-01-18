#!/bin/bash

## purpose: clean up pseudo-csv files from AHF
## author: Christian Pietsch <cpietsch@uni-bielefeld> http://purl.org/net/pietsch
## date: 2013-01-16
## dependencies: awk, R with package xslx (requires Java), GNU sed, tr

## BEGIN customize
FIELD_SEPARATOR='|'
INFILE_PATTERN="HB*_BI.[Cc]sv"
CORRECT_HEADER='Jahrgang|Gliederung|GldReg|GldSach|Autor|Autor_N_ID|Titel|Titel_In_WWW|InTitel_ID|InTitel|Intitel_Spk|Zs_Id|Zs_Name|Zs_Zdb_Id|dummy1|Band|Ort|Ort_Spk|Ort_Verlag_ID|Ort_Verlag|Ort_Verlag_Spk|Jahr|Seite|Reihe_Id|Reihe_Name|Reihe_Band|Reihe_Spk|Personen|Orte|Inst_Id1|Inst_Kurz1|Meld_Id1|Meld_Name1|InstId2|Inst_Kurz2|Meld_Id2|Meld_Name2|Spk_Allg|Isbn|Family_ID|Id|Fremd_Id|ErF_Datum|Up_Datum|Quelle|dummy2'
## END customize

NUMCOLS=$(echo "$CORRECT_HEADER" | tr "$FIELD_SEPARATOR" "\n" | wc -l)

function has_quoting_issue {
    grep -q '""' "$1"
}

function repair_quoting {
    sed -i -e 's/""/°°°REALQUOTE°°°/g' -e 's/"//g' -e 's/°°°REALQUOTE°°°/"/g' "$1"
}

function has_consistent_number_of_fields {
    awk "
BEGIN	 {
             FS=\"$FIELD_SEPARATOR\"
         }
//	 {
	     if (NF != $NUMCOLS) {
		 printf(\"Inconsistent number of columns (%d instead of $NUMCOLS) in line %d of file %s. Stopping check at this point.\n\", NF, NR, \"$infile\");
                 exit 1
	     };
         }" $1
}

function convert_to_real_csv {
    echo "
myDataFrame <- read.table(\"$1\", header=T, sep=\"|\", quote=\"\", dec=\",\")
myDataFrame\$Zs_Zdb_Id <- NULL     ## always empty
myDataFrame\$Autor_N_ID <- NULL    ## always empty
myDataFrame\$Zs_Id <- NULL         ## always 0
myDataFrame\$dummy1 <- NULL        ## inserted after Zs_Zdb_Id to make the data align correctly
myDataFrame\$dummy2 <- NULL        ## get rid of the superfluous semicolons in the last column
myDataFrame\$Fremd_Id <- NULL      ## always empty
write.csv(myDataFrame, file=\"real_$1\", na=\"\")  ## write real CSV
write.csv2(myDataFrame, file=\"excel_$1\", na=\"\", fileEncoding=\"ISO-8859-1\")  ## write CSV for Excel in Western Europe
library(\"xlsx\")
write.xlsx(myDataFrame, file=\"$1.xlsx\")
" | R --vanilla --slave
}

for infile in $INFILE_PATTERN
do
    if has_quoting_issue "$infile"
    then
	echo "Quoting issue in $infile. Repairing it ..."
	repair_quoting "$infile"
	echo "... done"
	
    fi

    if ! has_consistent_number_of_fields "$infile"
    then
	echo "Incorrect header suspected in $infile. Repairing it ..."
	tail -n+2 "$infile" > "$infile.headerless"
	echo "$CORRECT_HEADER" | cat - "$infile.headerless" > "$infile"
	if ! has_consistent_number_of_fields "$infile"
	then
	    echo '... failed. Ask Christian to create a new repair script, or get your own hands dirty!'
	    exit 2
	fi
	echo "... done."
    fi

    echo "File $infile should be OK now. Let's produce some CSV files from it."
    convert_to_real_csv "$infile"
done
echo "Finished repairing all CSV files."
