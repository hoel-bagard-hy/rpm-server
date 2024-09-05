#!/usr/bin/env bash

if [ ! -d "/data/packages/approved/el7-x86_64/repodata" ]; then
    createrepo /data/packages/approved/el7-x86_64/
fi

if [ ! -d "/data/packages/approved/el9-x86_64/repodata" ]; then
    createrepo /data/packages/approved/el9-x86_64/
fi

if [ ! -d "/data/packages/approval-pending/el7-x86_64/repodata" ]; then
    createrepo /data/packages/approval-pending/el7-x86_64/
fi

if [ ! -d "/data/packages/approval-pending/el9-x86_64/repodata" ]; then
    createrepo /data/packages/approval-pending/el9-x86_64/
fi

nginx -g 'daemon off;'
