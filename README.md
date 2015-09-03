# backup-restore-postgresql

Script for backup and restoring postgresql 

It follows http://www.postgresql.org/docs/9.3/static/continuous-archiving.html 


## Before Backup

Create archive directory and backup directory  in our case are 
> 
> `mkdir /archive`
> `mkdir /backup`
> 
> `chown postgres:postgres /archive`
> `chown postgres:postgres /backup`
> 

## Before restore

At every new restore create a new archivedir ( for example /archive_1 ) and change it in set_archive.bash  and in set_restore.bash .


## Commands

All commands have to be execute as postgres login

### set_archive.bash


This command will modify standard postgresql 9.3 configuration adding WAL Archiving (see 24.3.1 at http://www.postgresql.org/docs/9.3/static/continuous-archiving.html ).

WAL file will be written at /archive , ready to be used for a recovery.

A posgresql restart is needed

#### Example
> 
> `bash set_archive.bash`
> 
> `service postgresql restart`
>

### backup.bash


This command create a tar of entire PostgresSQL directory ***including pg_xlog directory*** 

Tar is located at /backup/YYYYMMDD/basebackup_last.tgz

Tar is located at /backup/YYYYMMDD/backup_BACKUPID_YYYYMMDDHHmmss.tgz


#### Example

> 
> `bash backup.bash`
> 
> 


### backup_wal_last.bash


This command create a tar of WAL file located /archive directory

Tar is located at /backup/archive_last.tgz

Tar is located at /backup/YYYYMMDD/archive_BACKUPID_YYYYMMDDHHmmss.tgz

A file /backup/last_archive_backup_label.info contain label of last archive log saved together with base backup done

#### Example

> 
> `bash backup_wal_last.bash`
> 
> 


## How to Restore 

See  [test_sequence.md](doc/test_sequence.md)

