#!/bin/bash
# Written by: Andrew Raymer
# Version:	2.0.0
# Date Last Modified: March 27th, 2022

set -e #Exit script on first error
# set -o xtrace ## Debugger

## User
# postgres

## Crontab
# 0 22 * * * /var/lib/postgresql/postgresql-backup.sh

# Variables
readonly TIMESTAMP=$(date +"%F_%H-%M")
readonly BASE_DIR="postgresql-backup"
readonly BACKUP_DIR="$BASE_DIR/databases"
readonly LOG_PATH="$BASE_DIR/log"
readonly RETENTION_PERIOD=14 # This is in DAYS

function log {
    # $1 log action
    if [ ! -d ./log ]; then
        mkdir -p $LOG_PATH
    fi
    log_timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    MSG="$1"
    printf '{"hostname":"%s","timestamp":"%s","message":"%s"}\n' "$(hostname)" "$log_timestamp" "$MSG" >> $LOG_PATH/backup-$(date +"%F").log
}

function main {
    cd ~

    mkdir -p "$BACKUP_DIR"
    
    databases=`psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
    
    for db in $databases; do
        if [ "$db" != "template0" ] && [ "$db" != "template1" ]; then
    
            mkdir -p "$BACKUP_DIR/$db"
            log "Dumping $db to $BACKUP_DIR/$db/${db}_${TIMESTAMP}.sql.gz"
            pg_dump $db | gzip > $BACKUP_DIR/$db/$db\_$TIMESTAMP.sql.gz
    
            ROTATE_LOG=$(find $BACKUP_DIR/$db -type f -prune -mtime +$RETENTION_PERIOD -exec rm -f {} \;)
    
            if [ -n "$ROTATE_LOG" ]; then
                log "$ROTATE_LOG has been rotated"
            fi
        fi
    
    done
}

# RUN
main