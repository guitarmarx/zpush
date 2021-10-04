#!/bin/bash

# common config
TIMEZONE=${TIMEZONE//\//\\/}
common_config_file="/etc/z-push/z-push.conf.php"
sed -i "s|('TIMEZONE', '')|('TIMEZONE', '$TIMEZONE')|g" $common_config_file
sed -i "s|('USE_FULLEMAIL_FOR_LOGIN'.*|('USE_FULLEMAIL_FOR_LOGIN', 'true');|g" $common_config_file
sed -i "s|('IPC_PROVIDER'.*|('IPC_PROVIDER', 'IpcSharedMemoryProvider');|g" $common_config_file
sed -i "s|('BACKEND_PROVIDER'.*|('BACKEND_PROVIDER', '$BACKEND_PROVIDER');|g" $common_config_file
#sed -i "s|('STATE_MACHINE'.*|('STATE_MACHINE', 'SQL')|g" $common_config_file

# imap config
imap_config_file="/etc/z-push/imap.conf.php"
sed -i "s|('IMAP_SERVER'.*|('IMAP_SERVER', '$IMAP_SERVER');|g" $imap_config_file
sed -i "s|('IMAP_PORT'.*|('IMAP_PORT', '$IMAP_PORT');|g" $imap_config_file
sed -i "s|('IMAP_FOLDER_CONFIGURED'.*|('IMAP_FOLDER_CONFIGURED', 'true');|g" $imap_config_file

# caldav config
caldav_config_file="/etc/z-push/caldav.conf.php"
sed -i "s|('CALDAV_PROTOCOL'.*|('CALDAV_PROTOCOL', '$CALDAV_PROTOCOL');|g" $caldav_config_file
sed -i "s|('CALDAV_SERVER'.*|('CALDAV_SERVER', '$CALDAV_SERVER');|g" $caldav_config_file
sed -i "s|('CALDAV_PORT'.*|('CALDAV_PORT', '$CALDAV_PORT');|g" $caldav_config_file
sed -i "s|('CALDAV_PATH'.*|('CALDAV_PATH', '$CALDAV_PATH');|g" $caldav_config_file
sed -i "s|('CALDAV_SUPPORTS_SYNC'.*|('CALDAV_SUPPORTS_SYNC', '$CALDAV_SUPPORTS_SYNC');|g" $caldav_config_file

# carddav config
carddav_config_file="/etc/z-push/carddav.conf.php"
sed -i "s|('CARDDAV_PROTOCOL'.*|('CARDDAV_PROTOCOL', '$CARDDAV_PROTOCOL');|g" $carddav_config_file
sed -i "s|('CARDDAV_SERVER'.*|('CARDDAV_SERVER', '$CARDDAV_SERVER');|g" $carddav_config_file
sed -i "s|('CARDDAV_PORT'.*|('CARDDAV_PORT', '$CARDDAV_PORT');|g" $carddav_config_file
sed -i "s|('CARDDAV_PATH'.*|('CARDDAV_PATH', '$CARDDAV_PATH');|g" $carddav_config_file
sed -i "s|('CARDDAV_DEFAULT_PATH'.*|('CARDDAV_DEFAULT_PATH', '$CARDDAV_DEFAULT_PATH');|g" $carddav_config_file
sed -i "s|('CARDDAV_SUPPORTS_SYNC'.*|('CARDDAV_SUPPORTS_SYNC', '$CARDDAV_SUPPORTS_SYNC');|g" $carddav_config_file


##########   Start Services   ############
apachectl -D FOREGROUND
