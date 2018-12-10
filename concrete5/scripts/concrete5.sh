#!/bin/sh


### This is because the way composer based concrete5 messes up with Full paths.
cd /var/www/vhosts/${SITE}

vendor/bin/concrete5 "$@"