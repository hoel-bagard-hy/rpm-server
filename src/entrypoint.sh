#!/usr/bin/env bash

if [ ! -d "/data/packages/el7-x86_64/repodata " ]; then
    createrepo /data/packages/el7-x86_64/
fi

nginx
