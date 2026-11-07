#!/bin/bash

DRY_RUN=0
WAIT_FOR_INPUT=1
WAIT_FOR_INPUT_ON_ERROR=1
PRINT_RETURNED_RESULT=1
SQL_DUMP_FOLDER_DEFAULT="/database"
SQL_DUMP_FOLDER_CREATED=""
BACKUP_FOLDER_DEFAULT="/backup"

echo_command() {
    local output=$1
    echo "$output"
}
echo_local_comment() {
    local output=$1
        echo_command "<# $output"
}
echo_remote_comment() {
    local output=$1
    echo_command "># $output"
}
echo_local_execute() {
    local output=$1
    echo_command "<= $output"
}
echo_remote_execute() {
    local output=$1
    echo_command ">= $output"
}
echo_local_error() {
    local output=$1
    echo_command "<! ERROR: $output"
}
echo_remote_error() {
    local output=$1
    echo_command ">! ERROR: $output"
}
echo_local_result() {
    local result=$1
    echo_command "<# Result: $result"
}
echo_remote_result() {
    local result=$1
    echo_command "># Result: $result"
}

execute_local() {
    # function parameters: 1: $execute, 2: $comment
    local execute=$1
    local comment=$2
    echo_local_comment ""
    if [ ! -z "$comment" ]; then
        echo_local_comment "$comment"
    fi
    if [ -z "$execute" ]; then
        echo_local_error "execute is not set"
        return 101
    fi
    echo_local_execute "$execute"
    if [ $DRY_RUN -eq 0 ]; then
        eval "$execute"
        result=$?
        if [ $PRINT_RETURNED_RESULT -eq 1 ]; then
            echo_local_result "$result"
        fi
        if [ $result -ne 0 ]; then
            echo_local_comment "********************** ERROR **********************"
            if [ $WAIT_FOR_INPUT_ON_ERROR -eq 1 ]; then
                read -p "=== Press Enter to continue ==="
            fi
        fi
    fi
    return $result
}

run_ssh_command_func() {
    # function parameters: 1: $execute, 2: $DESTINATION_IP, 3: $DESTINATION_PORT, 4: $DESTINATION_USERNAME, 5: $interactive
    if [ ! -z "$1" ]; then
        local execute=$1
    fi
    if [ ! -z "$2" ]; then
        DESTINATION_IP=$2
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_PORT=$3
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_USERNAME=$4
    else
        DESTINATION_USERNAME="root"
    fi
    if [ ! -z "$5" ]; then
        local interactive=$5
    else
        local interactive=0
    fi

    if [ -z "$execute" ]; then
        echo_local_error "execute is not set"
        return 101
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    if [ $interactive -eq 0 ]; then
        ssh $DESTINATION_USERNAME@$DESTINATION_IP -p $DESTINATION_PORT "$execute"
    else
        ssh -t $DESTINATION_USERNAME@$DESTINATION_IP -p $DESTINATION_PORT "$execute"
    fi
    return $?
}

run_rsync_remote_command_func() {
    # function parameters: 1: $SOURCE_PATH, 2: $DESTINATION_PATH, 3:RSYNC_OPTIONS, 4: $DESTINATION_IP, 5: $DESTINATION_PORT, 6: $DESTINATION_USERNAME, 7: $comment
    if [ ! -z "$1" ]; then
        local SOURCE_PATH=$1
    fi
    if [ ! -z "$2" ]; then
        local DESTINATION_PATH=$2
    else
        local DESTINATION_PATH="$SOURCE_PATH"
    fi
    if [ ! -z "$3" ]; then
        local RSYNC_OPTIONS=$3
    else
        local RSYNC_OPTIONS=""
    fi
    if [ ! -z "$4" ]; then
        local DESTINATION_IP=$4
    fi
    if [ ! -z "$5" ]; then
        local DESTINATION_PORT=$5
    else
        local DESTINATION_PORT="22"
    fi
    if [ ! -z "$6" ]; then
        local DESTINATION_USERNAME=$6
    else
        local DESTINATION_USERNAME="root"
    fi
    if [ ! -z "$7" ]; then
        local comment=$7
    else
        local comment=""
    fi

    if [ -z "$SOURCE_PATH" ]; then
        echo_local_error "SOURCE_PATH is not set"
        return 101
    fi
    if [ -z "$DESTINATION_PATH" ]; then
        echo_local_error "DESTINATION_PATH is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    if [ ! -z "$comment" ]; then
        echo_local_comment "$comment"
    fi
    echo_local_comment "Rsyncing to remote server $DESTINATION_IP: $SOURCE_PATH to $DESTINATION_PATH (options: $RSYNC_OPTIONS, username: $DESTINATION_USERNAME)"

    if [ "$DESTINATION_PORT" != "22" ]; then
        rsync_e="-e 'ssh -p $DESTINATION_PORT'"
    else
        rsync_e=""
    fi

    execute="rsync $RSYNC_OPTIONS $rsync_e $SOURCE_PATH $DESTINATION_USERNAME@$DESTINATION_IP:$DESTINATION_PATH"
    if [ $DRY_RUN -eq 0 ]; then
        eval "$execute"
        result=$?
        if [ $PRINT_RETURNED_RESULT -eq 1 ]; then
            echo_local_result "$result"
        fi
        if [ $result -ne 0 ]; then
            echo_local_comment "********************** ERROR **********************"
            if [ $WAIT_FOR_INPUT_ON_ERROR -eq 1 ]; then
                read -p "=== Press Enter to continue ==="
            fi
        fi
    else
        result=0
    fi
    return $result
}

execute_remote() {
    # function parameters: 1: $execute, 2: $comment, 3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    local execute=$1
    local comment=$2
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$execute" ]; then
        echo_local_error "execute is not set"
        return 101
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    echo_remote_comment ""
    if [ ! -z "$comment" ]; then
        echo_remote_comment "$comment"
    fi
    echo_remote_execute "$execute"
    if [ $DRY_RUN -eq 0 ]; then
        run_ssh_command_func "$execute" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME"
        result=$?
        if [ $PRINT_RETURNED_RESULT -eq 1 ]; then
            echo_remote_result "$result"
        fi
        if [ $result -ne 0 ]; then
            echo_remote_comment "********************** ERROR **********************"
            if [ $WAIT_FOR_INPUT_ON_ERROR -eq 1 ]; then
                read -p "=== Press Enter to continue ==="
            fi
        fi
    fi
    return $result
}

execute_remote_command_and_return_output_func() {
    # function parameters: 1: $execute, 2: $DESTINATION_IP, 3: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        local execute=$1
    fi
    if [ ! -z "$2" ]; then
        DESTINATION_IP=$2
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_PORT=$3
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_USERNAME=$4
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$execute" ]; then
        echo_local_error "execute is not set"
        return 101
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    ssh_output=$(run_ssh_command_func "$execute" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME")
    return_code=$?
    echo "$ssh_output"
    return $return_code
}

execute_remote_test_connection_func() {
    # function parameters: 1: $DESTINATION_IP, 2: $DESTINATION_PORT, 3: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        DESTINATION_IP=$1
    fi
    if [ ! -z "$2" ]; then
        DESTINATION_PORT=$2
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_USERNAME=$3
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    execute="echo 'test'"
    ssh_output=$(execute_remote_command_and_return_output_func "$execute" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME")
    if [ $? -ne 0 ]; then
        echo_local_error "SSH connection failed."
        return 1
    fi
    if [ "$ssh_output" != "test" ]; then
        echo_local_error "SSH connection failed, returned result is not 'test', but: $ssh_output"
        return 2
    fi
    return 0
}

export_rsync_import_empty_backup_func() {
    # function parameters: 1: $USERNAME, 2: $BACKUP_FOLDER, 3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        USERNAME=$1
    fi
    if [ ! -z "$2" ]; then
        BACKUP_FOLDER=$2
    else
        BACKUP_FOLDER="$BACKUP_FOLDER_DEFAULT"
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$USERNAME" ]; then
        echo_local_error "USERNAME is not set"
        return 101
    fi
    if [ -z "$BACKUP_FOLDER" ]; then
        echo_local_error "BACKUP_FOLDER is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    execute="/usr/local/vesta/bin/v-backup-user-empty $USERNAME"
    comment="Making empty backup for: $USERNAME"
    execute_local "$execute" "$comment"

    if [ $DRY_RUN -eq 0 ]; then
        BACKUP_FILE=$(ls -1t $BACKUP_FOLDER/$USERNAME*.tar | head -n 1)
    else
        BACKUP_FILE="/backup/dummy.tar"
    fi
    BACKUP_FILE_NAME=$(basename $BACKUP_FILE)
    echo_local_comment "Backup file: $BACKUP_FILE"

    execute="mkdir -p $BACKUP_FOLDER"
    comment="Creating: $BACKUP_FOLDER on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    run_rsync_remote_command_func "$BACKUP_FILE" "" "" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME" "Copying to remote server empty backup for user: $USERNAME"
    echo_local_comment "Done copying empty backup for: $USERNAME to ${DESTINATION_IP}:$BACKUP_FILE"

    if [ -f $BACKUP_FILE ]; then
        execute="rm $BACKUP_FILE"
        comment="Removing: $BACKUP_FILE on local machine"
        execute_local "$execute" "$comment"
    else
        echo_local_comment "Removing: $BACKUP_FILE on local machine"
    fi

    execute="source /etc/profile; PATH=$PATH:/usr/local/vesta/bin; export PATH; OVERRIDE_BACKUP_PATH='$BACKUP_FOLDER'; export OVERRIDE_BACKUP_PATH; /usr/local/vesta/bin/v-restore-user '$USERNAME' '${BACKUP_FILE_NAME}'"
    comment="Importing empty backup for: $USERNAME on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    execute="source /etc/profile; PATH=$PATH:/usr/local/vesta/bin; export PATH; /usr/local/vesta/bin/v-normalize-restored-user '$USERNAME'"
    comment="Normalizing restored user $USERNAME on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    execute="rm $BACKUP_FILE"
    comment="Removing: $BACKUP_FILE on remote server $DESTINATION_IP after import"
    execute_remote "$execute" "$comment"
}

rsync_vhost_web_func() {
    # function parameters: 1: $USERNAME, 2: $vhost, 3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        USERNAME=$1
    fi
    if [ ! -z "$2" ]; then
        vhost=$2
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$USERNAME" ]; then
        echo_local_error "USERNAME is not set"
        return 101
    fi
    if [ -z "$vhost" ]; then
        echo_local_error "vhost is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    echo_local_comment "Rsyncing web: $vhost"
    run_rsync_remote_command_func "/home/$USERNAME/web/$vhost/" "" "-az --delete" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME" "Rsyncing web: $vhost to remote server $DESTINATION_IP:/home/$USERNAME/web/$vhost/"
    echo_local_comment "Done rsyncing web: $vhost to remote server $DESTINATION_IP:/home/$USERNAME/web/$vhost/"
    echo_local_comment ""
}

rsync_vhost_mail_func() {
    # function parameters: 1: $USERNAME, 2: $vhost, 3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        USERNAME=$1
    fi
    if [ ! -z "$2" ]; then
        vhost=$2
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$USERNAME" ]; then
        echo_local_error "USERNAME is not set"
        return 101
    fi
    if [ -z "$vhost" ]; then
        echo_local_error "vhost is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    echo_local_comment "Rsyncing mail: $vhost"

    run_rsync_remote_command_func "/home/$USERNAME/mail/$vhost/" "" "-az --delete" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME" "Rsyncing mail: $vhost to remote server $DESTINATION_IP:/home/$USERNAME/mail/$vhost/"
    echo_local_comment "Done rsyncing mail: $vhost to remote server $DESTINATION_IP:/home/$USERNAME/mail/$vhost/"
    echo_local_comment ""
}

export_rsync_import_databases_func() {
    # function parameters: 1: $database, 2: $SQL_DUMP_FOLDER,3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        local database=$1
    fi
    if [ ! -z "$2" ]; then
        SQL_DUMP_FOLDER=$2
    else
        SQL_DUMP_FOLDER="$SQL_DUMP_FOLDER_DEFAULT"
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$database" ]; then
        echo_local_error "database is not set"
        return 101
    fi
    if [ -z "$SQL_DUMP_FOLDER" ]; then
        echo_local_error "SQL_DUMP_FOLDER is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    if [ "$SQL_DUMP_FOLDER" != "$SQL_DUMP_FOLDER_CREATED" ]; then
        execute="mkdir -p $SQL_DUMP_FOLDER"
        comment="Creating: $SQL_DUMP_FOLDER on local machine"
        execute_local "$execute" "$comment"
        comment="Creating: $SQL_DUMP_FOLDER on remote server $DESTINATION_IP"
        execute_remote "$execute" "$comment"
        SQL_DUMP_FOLDER_CREATED="$SQL_DUMP_FOLDER"
    fi

    FILENAME="${database}.sql"
    execute="nice -n 19 ionice -c 3 mysqldump --complete-insert --force --quick --single-transaction --max-allowed-packet=1024MB -h localhost ${database} > $SQL_DUMP_FOLDER/${FILENAME}"
    comment="Dumping database $database to ${SQL_DUMP_FOLDER}/${FILENAME} on local machine"
    execute_local "$execute" "$comment"
    if [ $? -ne 0 ]; then
        echo_local_error "mysqldump failed for $database"
        if [ -f "$SQL_DUMP_FOLDER/${FILENAME}" ]; then
            execute="rm $SQL_DUMP_FOLDER/${FILENAME}"
            comment="Removing: $SQL_DUMP_FOLDER/${FILENAME} on local machine"
            execute_local "$execute" "$comment"
        fi
        return 1
    fi
    
    execute="nice -n 19 ionice -c 3 gzip $SQL_DUMP_FOLDER/${FILENAME}"
    comment="Gziping ${FILENAME} to ${FILENAME}.gz on local machine"
    execute_local "$execute" "$comment"
    if [ $? -ne 0 ]; then
        echo_local_error "gzip failed for ${FILENAME}"
        if [ -f "$SQL_DUMP_FOLDER/${FILENAME}" ]; then
            execute="rm $SQL_DUMP_FOLDER/${FILENAME}"
            comment="Removing: $SQL_DUMP_FOLDER/${FILENAME} on local machine"
            execute_local "$execute" "$comment"
        fi
        if [ -f "$SQL_DUMP_FOLDER/${FILENAME}.gz" ]; then
            execute="rm $SQL_DUMP_FOLDER/${FILENAME}.gz"
            comment="Removing: $SQL_DUMP_FOLDER/${FILENAME}.gz on local machine"
            execute_local "$execute" "$comment"
        fi
        return 2
    fi
    echo_local_comment "Done dumping database $database to ${SQL_DUMP_FOLDER}/${FILENAME}.gz on local machine"

    run_rsync_remote_command_func "$SQL_DUMP_FOLDER/$FILENAME.gz" "" "" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME" "Copying to remote server: $SQL_DUMP_FOLDER/$FILENAME.gz"

    execute="rm $SQL_DUMP_FOLDER/$FILENAME.gz"
    comment="Removing: $SQL_DUMP_FOLDER/$FILENAME.gz on local machine"
    execute_local "$execute" "$comment"

    execute="gunzip $SQL_DUMP_FOLDER/$FILENAME.gz"
    comment="Unzipping: $SQL_DUMP_FOLDER/$FILENAME.gz on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    execute="mysql ${database} < $SQL_DUMP_FOLDER/$FILENAME"
    comment="Restoring: $database from $SQL_DUMP_FOLDER/$FILENAME on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    execute="rm $SQL_DUMP_FOLDER/$FILENAME"
    comment="Removing: $SQL_DUMP_FOLDER/$FILENAME on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"
    echo_remote_comment "Done restoring: $database from $SQL_DUMP_FOLDER/$FILENAME on remote server $DESTINATION_IP"
    return 0
}

switch_vhost_prepare_func() {
    if [ ! -f "/usr/local/vesta/data/templates/web/nginx/forward.sh" ]; then
        wget -nv -O /usr/local/vesta/data/templates/web/nginx/forward.sh http://dl.myvestacp.com/vesta/vesta-cp-nginx-tpl/fwd-http2/forward.sh
        wget -nv -O /usr/local/vesta/data/templates/web/nginx/forward.tpl http://dl.myvestacp.com/vesta/vesta-cp-nginx-tpl/fwd-http2/forward.tpl
        wget -nv -O /usr/local/vesta/data/templates/web/nginx/forward.stpl http://dl.myvestacp.com/vesta/vesta-cp-nginx-tpl/fwd-http2/forward.stpl
        chmod a+x /usr/local/vesta/data/templates/web/nginx/forward.sh
    fi
}

switch_vhost_func() {
    # function parameters: 1: $USERNAME, 2: $vhost, 3: $DESTINATION_IP, 4: $DESTINATION_PORT, 5: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        USERNAME=$1
    fi
    if [ ! -z "$2" ]; then
        vhost=$2
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_IP=$3
    fi
    if [ ! -z "$4" ]; then
        DESTINATION_PORT=$4
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$5" ]; then
        DESTINATION_USERNAME=$5
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$USERNAME" ]; then
        echo_local_error "USERNAME is not set"
        return 101
    fi
    if [ -z "$vhost" ]; then
        echo_local_error "vhost is not set"
        return 102
    fi
    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    execute="/usr/local/vesta/bin/v-list-web-domain '$USERNAME' '$vhost' | grep '^IP:' | awk '{ print \$2 }'"
    SOURCE_IP=$(eval "$execute")
    if [ -z "$SOURCE_IP" ]; then
        echo_local_error "SOURCE_IP is not set"
        return 111
    fi

    execute="export VESTA='/usr/local/vesta'; $execute"
    TARGET_IP=$(execute_remote_command_and_return_output_func "$execute")
    if [ -z "$TARGET_IP" ]; then
        echo_local_error "TARGET_IP is not set"
        return 112
    fi

    echo_local_comment "Switching web proxy for: $vhost"

    execute="if grep -q \"$SOURCE_IP\" /home/$USERNAME/conf/dns/$vhost.db; then sed -i \"s#$SOURCE_IP#$TARGET_IP#g\" /home/$USERNAME/conf/dns/$vhost.db; fi"
    comment="Replacing $SOURCE_IP with $TARGET_IP in /home/$USERNAME/conf/dns/$vhost.db"
    execute_local "$execute" "$comment"
    execute_remote "$execute" "$comment"
    
    execute="if grep -q \"$SOURCE_IP\" /usr/local/vesta/data/users/$USERNAME/dns/$vhost.conf; then sed -i \"s#$SOURCE_IP#$TARGET_IP#g\" /usr/local/vesta/data/users/$USERNAME/dns/$vhost.conf; fi"
    comment="Replacing $SOURCE_IP with $TARGET_IP in /usr/local/vesta/data/users/$USERNAME/dns/$vhost.conf"
    execute_local "$execute" "$comment"
    execute_remote "$execute" "$comment"

    execute="/usr/local/vesta/bin/v-change-dns-domain-ip  '$USERNAME' '$vhost' '$TARGET_IP' 'no'"
    comment="Changing DNS domain IP for $vhost to $TARGET_IP on local machine"
    execute_local "$execute" "$comment"
    execute="source /etc/profile; PATH=$PATH:/usr/local/vesta/bin; export PATH; /usr/local/vesta/bin/v-change-dns-domain-ip  '$USERNAME' '$vhost' '$TARGET_IP' 'no'"
    comment="Changing DNS domain IP for $vhost to $TARGET_IP on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment"

    execute="echo \"$TARGET_IP\" > /home/$USERNAME/conf/web/forward-$vhost.txt"
    comment="Writing $TARGET_IP to /home/$USERNAME/conf/web/forward-$vhost.txt"
    execute_local "$execute" "$comment"

    execute="/usr/local/vesta/bin/v-change-web-domain-proxy-tpl '$USERNAME' '$vhost' 'forward' 'txt' 'no'"
    comment="Changing web domain proxy template for $vhost to 'forward'"
    execute_local "$execute" "$comment"
}

switch_vhost_finish_func() {
    # function parameters: 1: $DESTINATION_IP, 2: $DESTINATION_PORT, 3: $DESTINATION_USERNAME
    if [ ! -z "$1" ]; then
        DESTINATION_IP=$1
    fi
    if [ ! -z "$2" ]; then
        DESTINATION_PORT=$2
    else
        DESTINATION_PORT="22"
    fi
    if [ ! -z "$3" ]; then
        DESTINATION_USERNAME=$3
    else
        DESTINATION_USERNAME="root"
    fi

    if [ -z "$DESTINATION_IP" ]; then
        echo_local_error "DESTINATION_IP is not set"
        return 110
    fi

    execute="systemctl restart nginx"
    comment="Restarting nginx on local machine"
    execute_local "$execute" "$comment"

    execute="systemctl reload bind9"
    comment="Reloading bind9 on local machine"
    execute_local "$execute" "$comment"
    comment="Reloading bind9 on remote server $DESTINATION_IP"
    execute_remote "$execute" "$comment" "$DESTINATION_IP" "$DESTINATION_PORT" "$DESTINATION_USERNAME"
    return 0
}
