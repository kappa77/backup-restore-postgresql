# Test Sequence

## Prepare enviroment

mkdir /archive
mkdir /archive/restore
mkdir /backup
chown postgres  /archive
chown postgres  /archive/restore
chown postgres  /backup


## Reset database data

su - postgres

pg_dropcluster 9.4 main --stop
pg_createcluster 9.4 main
rm /archive/0*

bash set_archive.bash

service postgresql start

## Create database

bash test_setup.bash

bash add_rows.bash
bash add_rows.bash
bash check_table.bash
  
---  300000

## Make backup 

### Base backup

bash backup.bash

bash check_table.bash

### WAL archive backup 

bash backup_wal_last.bash

bash add_rows.bash
bash add_rows.bash
bash check_table.bash
  
  ---- 500000
  
bash backup_wal_last.bash

bash add_rows.bash
bash add_rows.bash
bash check_table.bash

 ---- 700000

### Restore

#### Fault simulation 

rm -fr 9.4/main/*

ps aux | grep postgres

#### Restore with archive in tgz only

mkdir 9.4/main/pg_xlog

tar xzf /backup/basebackup_last.tgz -C /

rm /archive/restore/*

tar xzf /backup/archive_last.tgz  -C /archive/restore/ 

bash set_restore.bash

#### Open a tail -f session to see error on postgresql log


service postgresql start

bash check_table.bash 

-- should be 500000



#### Restore with archive in tgz and in /archive/ ( same first 20 digits ).

mkdir 9.4/main/pg_xlog

tar xzf /backup/basebackup_last.tgz -C /

rm /archive/restore/*

tar xzf /backup/archive_last.tgz  -C /archive/restore/ 

bash set_restore.bash

#### Open a tail -f session to see error on postgresql log


service postgresql start

bash check_table.bash 


-- should be 700000

