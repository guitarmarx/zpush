FROM  debian:10.11
LABEL maintainer="meteorIT GbR Marcus Kastner"

VOLUME /var/lib/z-push/

EXPOSE 80

ENV DEBIAN_FRONTEND=noninteractive \
	TIMEZONE="Europe/Berlin" \
	IMAP_SERVER=localhost \
	IMAP_PORT=143 \
	BACKEND_PROVIDER=BackendIMAP \
	CALDAV_PROTOCOL=https \
	CALDAV_SERVER="<caldav-server>" \
	CALDAV_PORT=443 \
	CALDAV_PATH="/remote.php/dav/calendars/%l/" \
	CALDAV_SUPPORTS_SYNC=true \
	CARDDAV_PROTOCOL=https \
	CARDDAV_SERVER="<caldav-server>" \
	CARDDAV_PORT=443 \
	CARDDAV_PATH="/remote.php/dav/addressbooks/users/%u/contacts/" \
	CARDDAV_DEFAULT_PATH="/remote.php/dav/addressbooks/users/%u/contacts/" \
	CARDDAV_SUPPORTS_SYNC=true
	

# install basic packages
RUN apt update \
	&& apt install -y \
	curl \
	gnupg2 \
	lsb-release \
	apt-transport-https \
	&& apt clean && rm -rf /var/lib/apt/lists/*

# add php repo
RUN curl https://packages.sury.org/php/apt.gpg > /usr/share/keyrings/php-archive-keyring.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
	
# add z-push repo
RUN curl https://download.kopano.io/zhub/z-push:/final/Debian_10/Release.key | gpg --dearmor > /usr/share/keyrings/z-push-archive-keyring.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/z-push-archive-keyring.gpg] https://download.kopano.io/zhub/z-push:/final/Debian_10/ /" > /etc/apt/sources.list.d/zpush.list
	

RUN apt update \
	&& apt install -y \
	php7.4 \
	z-push-common \
	z-push-config-apache \
	z-push-backend-caldav \
	z-push-backend-carddav \
	z-push-backend-combined \
	z-push-backend-imap \
	z-push-state-sql \
	z-push-autodiscover \
	z-push-ipc-sharedmemory \
	&& apt clean && rm -rf /var/lib/apt/lists/* 
	
	
ADD entrypoint.sh /srv
RUN chmod +x /srv/entrypoint.sh \
	&& mkdir -p  /var/log/z-push /usr/share/z-push /var/lib/z-push \
	&& chown -R  www-data:www-data /var/log/z-push /usr/share/z-push /var/lib/z-push
ENTRYPOINT /srv/entrypoint.sh
