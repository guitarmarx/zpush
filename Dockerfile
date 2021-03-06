FROM  ubuntu:20.04
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
	CALDAV_PERSONAL="personal" \
	CARDDAV_PROTOCOL=https \
	CARDDAV_SERVER="<caldav-server>" \
	CARDDAV_PORT=443 \
	CARDDAV_PATH="/remote.php/dav/addressbooks/users/%l/contacts/" \
	CARDDAV_DEFAULT_PATH="/remote.php/dav/addressbooks/users/%l/contacts/" \
	CARDDAV_SUPPORTS_SYNC=true
	

# install basic packages
RUN apt update \
	&& apt install -y \
	curl \
	gnupg2 \
	lsb-release \
	apt-transport-https \
	&& apt clean && rm -rf /var/lib/apt/lists/*


# add z-push repo
RUN curl https://download.kopano.io/zhub/z-push:/final/Ubuntu_20.04/Release.key | gpg --dearmor > /usr/share/keyrings/z-push-archive-keyring.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/z-push-archive-keyring.gpg] https://download.kopano.io/zhub/z-push:/final/Ubuntu_20.04/ /" > /etc/apt/sources.list.d/zpush.list
	

RUN apt update \
	&& apt install -y \
	php \
	libapache2-mod-php \
	php-mbstring \
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
	
ADD combined.conf.php /tmp	
ADD entrypoint.sh /srv
RUN chmod +x /srv/entrypoint.sh \
	&& mkdir -p  /var/log/z-push /usr/share/z-push /var/lib/z-push /usr/share/php \
	&& chown -R www-data:www-data \
	/var/log/z-push \
	/usr/share/z-push \
	/var/lib/z-push \
	&& ln -s /usr/share/awl/inc/* /usr/share/php 
	
ENTRYPOINT /srv/entrypoint.sh
