#|/bin/bash
data=`date +%Y%m%d%H%M%s`
ARCHIVEDIR=/archive
ARCHIVEBKP=/backup/archive/$data
TARARCFILE=$ARCHIVEBKP/archive_${data}.tgz

echo $ARCHIVEBKP

echo "Primo argomente $1"
 
test ! -d $ARCHIVEBKP && mkdir $ARCHIVEBKP

tar czf  $TARARCFILE $ARCHIVEDIR 


