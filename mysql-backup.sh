#!/bin/bash
# Written by: Andrew Raymer
# Version:	2.0.0
# Date Last Modified: March 27th, 2022

set -e #Exit script on first error
# set -o xtrace ## Debugger

## User
# backups

## Crontab
# 0 23 * * * /home/backups/mysql-backup.sh

# Variables
readonly TIMESTAMP=$(date +"%F_%H-%M")
readonly BASE_DIR="mysql-backup"
readonly BACKUP_DIR="$BASE_DIR/databases"
readonly FULLBACKUP_DIR="$BASE_DIR/Fullbackup"
readonly MYSQL_USER="admin"
readonly MYSQL_PASSWORD='TopsyKretPasswords'
readonly LOG_PATH="$BASE_DIR/log"
readonly RETENTION_PERIOD=14 # This is in DAYS

# Functions
function log {
    # $1 log action
    if [ ! -d $LOG_PATH ]; then
        mkdir -p $LOG_PATH
    fi
    log_timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    MSG="$1"
    printf '{"hostname":"%s","timestamp":"%s","message":"%s"}\n' "$(hostname)" "$log_timestamp" "$MSG" >> $LOG_PATH/backup-$(date +"%F").log
}

function individual_backups {
    # This fetches all the databases that are in MySQL and puts them into an array
    if [ -z "$MYSQL_PASSWORD" ]; then
        databases=$(mysql --user=$MYSQL_USER -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")
        log "No MySQL password was given for user $MYSQL_USER"
    else
        databases=$(mysql --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")
    fi
    
    # I
    for db in $databases; do
        # Make the directory
        mkdir -p "$BACKUP_DIR/$db"
        if [ -z "$MYSQL_PASSWORD" ]; then
            mysqldump --force --opt --user=$MYSQL_USER --databases $db | gzip > "$BACKUP_DIR/$db/$db-$TIMESTAMP.sql.gz"
        else
            mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$db/$db-$TIMESTAMP.sql.gz"
        fi
        
        log "$db has been backed up"
        ROTATE_LOG=$(find $BACKUP_DIR/$db -type f -prune -mtime +$RETENTION_PERIOD -exec rm -f {} \;)
        
        if [ -n "$ROTATE_LOG" ]; then
            log "$ROTATE_LOG has been rotated"
        fi
        
        ROTATE_LOG=$(find $LOG_PATH -type f -prune -mtime +$RETENTION_PERIOD -exec rm -f {} \;)
        
        if [ -n "$ROTATE_LOG" ]; then
            log "FullDatabase: $ROTATE_LOG has been rotated"
        fi
    done  
}

function full_backup {
    mkdir -p "$FULLBACKUP_DIR"
    if [ -z "$MYSQL_PASSWORD" ]; then
        # mysqldump --user=$MYSQL_USER -–all-databases | gzip > file.sql.gz
        log "Taking Full Database Snapshot"
        mysqldump --force --opt --user=$MYSQL_USER --all-databases | gzip > "$FULLBACKUP_DIR/Fullbackup-$TIMESTAMP.sql.gz"
        log "Full Database Snapshot complete"
    else
        # mysqldump --user=$MYSQL_USER -p$MYSQL_PASSWORD --all-databases | gzip > file.sql.gz
        log "Taking Full Database Snapshot"
        mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --all-databases | gzip > "$FULLBACKUP_DIR/Fullbackup-$TIMESTAMP.sql.gz"
        log "Full Database Snapshot complete"
    fi
}

function main {
    cd ~
    mkdir -p "$BACKUP_DIR"
    individual_backups
    full_backup
}

# run
main