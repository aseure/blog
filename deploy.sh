#!/usr/bin/env bash

rsync -e 'ssh -i ~/.ssh/scaleway' -avz --delete public root@212.47.249.142:/var/www/
