#!/bin/bash
datatime=`date +%Y%m%d%H%M%s`
data=`date +%Y%m%d`
ARCHIVENAME=archive
ARCHIVEDIR=/$ARCHIVENAME
ARCHIVEBKPBASE=/backup/
ARCHIVEBKP=$ARCHIVEBKPBASE/$data

echo $ARCHIVEBKP

 
test ! -d $ARCHIVEBKPBASE && mkdir $ARCHIVEBKPBASE
test ! -d $ARCHIVEBKP && mkdir $ARCHIVEBKP


lastbackup=`ls -r /archive/ | grep backup$  | head -n 1 | cut -d'.' -f 1 `

echo "Last backup in archive $lastbackup"

files=""

psql -c "select pg_switch_xlog()"

for i in `ls -r $ARCHIVEDIR | grep -v tmp `; do 
if [  -f $ARCHIVEDIR"/"$i ] 
then 
  if  [ "$i" \> "$lastbackup" ] || [[  "$i" = "$lastbackup" ]] 
  then 
      echo "To archive ${i} : ${i} \> $lastbackup " 
      if  [[  "$i" = "$lastbackup" ]]
      then  
          echo "$i = $lastbackup"
      fi
      if [ "$i" \> "$lastbackup" ]
      then 
          echo "Reason : $i > ${lastbackup}"
      fi
      echo "lastbackup ${lastbackup}"	
      files="${files} ${i}" 
  else 
      echo "To ignore ${i}"
  fi 
else
  echo "To ignore $ARCHIVEDIR / ${i}"
fi ; 
done

echo $files

TARARCFILE=$ARCHIVEBKP/archive_${lastbackup}_${datatime}.tgz 

tar -C $ARCHIVEDIR -czf  $TARARCFILE $files 

cp -f $TARARCFILE $ARCHIVEBKPBASE/archive_last.tgz

echo ${lastbackup} > $ARCHIVEBKPBASE/last_archive_backup_label.info

echo "Tar file created : in $TARARCFILE"
