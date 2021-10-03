#!/bin/bash

# general config
TIMEZONE=${TIMEZONE//\//\\/}
sed -i "s/('TIMEZONE', '')/('TIMEZONE', '$TIMEZONE')/g" /etc/z-push/z-push.conf.php
sed -i "s/('USE_FULLEMAIL_FOR_LOGIN'.*/('USE_FULLEMAIL_FOR_LOGIN', 'true');/g" /etc/z-push/z-push.conf.php
sed -i "s/('BACKEND_PROVIDER'.*/('BACKEND_PROVIDER', 'BackendIMAP');/g" /etc/z-push/z-push.conf.php

# imap config
sed -i "s/('IMAP_SERVER'.*/('IMAP_SERVER', '$IMAP_SERVER');/g" /etc/z-push/imap.conf.php
sed -i "s/('IMAP_SERVER'.*/('IMAP_PORT', '$IMAP_PORT');/g" /etc/z-push/imap.conf.php

sed -i "s/('IMAP_FOLDER_CONFIGURED'.*/('IMAP_FOLDER_CONFIGURED', 'true');/g" /etc/z-push/imap.conf.php



#sed -i "s/('STATE_MACHINE'.*/('STATE_MACHINE', 'SQL')/g" /etc/z-push/z-push.conf.php


##########   Start Services   ############
apachectl -D FOREGROUND
