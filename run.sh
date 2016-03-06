#!/bin/bash
set -m

if [ -f /data/db/mongod.lock ]; then
  echo "Lock file detected.. "
  mongopid=`pidof mongod`
  if [ -n "$mongod" ]; then
    echo "A mongod process is already running. It has pid $mongopid"
  else
    rm /data/db/mongod.lock
  fi
fi

mongodb_cmd="mongod"
cmd="$mongodb_cmd --smallfiles --httpinterface --rest"
if [ "$AUTH" == "yes" ]; then
  cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "no" ]; then
  cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
  cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

if [ "$REPLICA_SET" ]; then
  cmd="$cmd --replSet $REPLICA_SET"
fi

$cmd &

if [ ! -f /data/db/.mongodb_password_set ]; then
  /set_mongodb_password.sh
fi

fg
