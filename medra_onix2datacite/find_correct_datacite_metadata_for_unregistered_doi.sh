for i in metadata_article_number_*.url ;
do
  URL=$(<$i) 
  SDOI=$(< ${i%.url}.doi)
  TDOI=$(curl -sL http://doi.org/$SDOI | awk -F '"' '/DC.Identifier.DOI/ {print $4}')
  echo "$URL – $SDOI – found online in OJS HTML metadata – $TDOI"
  GOODXML=$(fgrep -li "$TDOI" ../../../datacite/jsse_datacite-export/*.xml)
  cat $GOODXML | sed -e s,$TDOI,$SDOI,i > patched_datacite_${i%.url}.xml
  echo -n $TDOI > "${i%.url}.doi.recorrected"
done
