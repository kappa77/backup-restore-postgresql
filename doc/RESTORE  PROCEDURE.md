# Example of Restore

## Set up test database

su - postgres
pg_dropcluster 9.3 main --stop
 
pg_createcluster 9.3 main

bash set_archive.bash

service postgresql start


## Insert test data 
echo "create table test(id serial,value integer) ;" | psql 
echo "insert into test(value) select v.a from generate_series(1,2400000)as v(a) ;" | psql 
echo "select max(id) from test" | psql 
echo "2400000"

## Backup

bash backup.bash

## Insert data after backup 

echo "insert into test(value) select v.a from generate_series(1,2400000)as v(a) ;" | psql 

echo "select max(id) from test" | psql 
echo "4800000"
echo "insert into test(value) select v.a from generate_series(1,2400000)as v(a) ;" | psql 

echo "select pg_switch_xlog();" | psql 
echo "select max(id) from test" | psql 
echo "7200000"

## Insert data after forcing archive log

echo "insert into test(value) select v.a from generate_series(1,2400000)as v(a) ;" | psql 
echo "select max(id) from test" | psql 
echo "9600000"
 

## Simulate file system error 

rm -fr 9.3/main/base

rm -fr 9.3/main/pg_xlog/

psql

## Recovery

echo " RECOVERY"

service postgresql stop

echo " RECOVERY RIGHT BACKUP "


## Set up recovery WAL file

rm /archive/restore/*
cp /archive/* /archive/restore/

## Extract full backup from tar

tar vxzf    /backup/20150821073404/bckp_20150821073404.tar.tgz   -C /

## Set up recovery mode

bash set_restore.bash

## Recovery

service postgresql start

echo "select count(id) from test" | psql
echo "7200000"

echo "insert into test(value) select v.a from generate_series(1,2400000)as v(a) ;" | psql 
echo "select count(id) from test" | psql 
echo "9600000"
echo "select pg_switch_xlog();" | psql

