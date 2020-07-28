#!/bin/bash

declare sem_count=2
declare max_allowed_sem_count=2
declare  fpath=locks
declare  mastfile=$fpath/.master.lock
declare -r wait_master_ts=3

function read_sem_count() {
    flock -x $mastfile -c "cat $mastfile"
}

function add_sem_count() {
    if [[ $# -ne 1 ]]; then
        echo "wrong # args to add_sem_count = $#. exit"
        exit -1
    fi
    local add_=$1
    local old
    {
        flock 3
        old=$(cat $mastfile)
        echo $(( $old + $add_ )) | tee $mastfile
    } 3<$mastfile
}

function cmp_exch_sem_count() {
    if [[ $# -ne 2 ]]; then
        echo "wrong # args to add_sem_count = $#. exit"
        exit -1
    fi
    local expected=$1
    local new=$2
    {
        flock 3
        old=$(cat $mastfile)
#        echo got old = $old, cat $mastfile >&2
        if [[ $old -ne $expected ]];then
            echo 0
        else
            echo 1
            echo $new > $mastfile
        fi
    } 3<$mastfile
}
function wait() {
    local old=$(read_sem_count)
    if [[ $old -le 0 ]]; then
        echo 0
        return;
    else
        local try_=$(cmp_exch_sem_count $old $(( $old - 1 )) )
        echo $try_
    fi
}
function signal() {
    inc_sem_count
}
function set_sem_count() {
    if [[ $# -ne 1 ]]; then
        echo "wrong # args to add_sem_count = $#. exit"
        exit -1
    fi
    local add_=$1
    local old
    {
        flock 3
        echo $(( $add_ )) | tee $mastfile
    } 3<$mastfile
}

function inc_sem_count() {
    add_sem_count 1
}
function dec_sem_count() {
    add_sem_count -1
}


function locked_exec() {
    echo "got req [$@]" >&2
    while [[ $(read_sem_count) -le 0 ]]; do
        echo "waiting... $@" >&2
        sleep $wait_master_ts
    done
    local com="$@"
    local try_lock=$(wait)
    if [[ $try_lock -ne 1 ]];then
        locked_exec "$@"
        return
    else
        eval "$com"
        signal
    fi
}

function init() {
    set_sem_count $max_allowed_sem_count
}
init
