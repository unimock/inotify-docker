#!/bin/bash

L_USER="<minio-user>"
L_PASS="<minio-password>"
L_URL="<minio-url>"

#echo "running: `basename $0` $*"

FI=${1}${3}
if [ "$2" = "CREATE" ] ; then
  if [ "$1" = "/fax/" ] ; then
    sleep 3
    echo "detect new file <$FI> in fax section"
    i=${3%_*}
    if [ "$i" = "00*" ] ; then
       _nr=$i       # International
    else
       _nr=0049${i/0} #National
    fi
    _type=$(file --mime-type $FI | cut -d " " -f2)
    PARAM_ATTACH=" --attach-type \"$_type\" --attach   @${FI} "
    swaks \
      --to     ${_nr}@my.fax.provider \
      --from   scan@company.de    \
      --server smtp.server.intra  \
      --header "Subject: xyz" \
      --body " " \
      $PARAM_ATTACH
  fi
  if [ "$1" = "/print/" ] ; then
    echo "detect new file <$FI> in print section"
    sleep 20
    ls -la $FI
    lpr -H cupsd.server.intra:631 -P Office-Printer  $FI
    echo "lpr -H cupsd.server.intra:631 -P Office-Printer $FI"
  fi
  if [[ $1 == "/fibu/"* ]]; then
    echo "detect new file <$FI> in fibu section"
    sleep 3
    FI=${1}${3}
    FI=${FI%.part}
    # mc ls fibushare
    # mc ls fibushare/exchange/Allgemein
    if [ ! -d /root/.mc ] ; then
      mc config host add fibushare ${L_URL} ${L_USER} ${L_PASS}
    fi
    target=${1#/fibu/}
    DAT=fibushare/fibu/${target}
    echo mc cp ${FI} ${DAT}
    mc      cp ${FI} ${DAT}
  fi
  rm -f $FI
  echo "remove: $FI" 
fi

exit 0

