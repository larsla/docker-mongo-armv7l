#!/bin/bash

MONGODB1=${MONGODB1:-mongodb1}
MONGODB2=${MONGODB2:-mongodb2}
MONGODB3=${MONGODB3:-mongodb3}

echo "Waiting for startup.."
until curl http://${MONGODB1}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo curl http://${MONGODB1}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
echo "Started.."


echo SETUP.sh time now: `date +"%T" `
mongo --host ${MONGODB1}:27017 <<EOF
   var cfg = {
        "_id": "${REPLICA_SET}",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "${MONGODB1}:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "${MONGODB2}:27017",
                "priority": 0
            },
            {
                "_id": 2,
                "host": "${MONGODB3}:27017",
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF
