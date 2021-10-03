FROM  php:7.4.24-apache-buster
LABEL maintainer="meteorIT GbR Marcus Kastner"

VOLUME /var/lib/z-push/

EXPOSE 443

ENV DEBIAN_FRONTEND=noninteractive \
	TIMEZONE="Europe/Berlin" \
	IMAP_SERVER=localhost \
	IMAP_PORT=143 
	

# install basic packages
RUN apt-get update \
	&& apt-get install -y curl gnupg2 \
	&& rm /etc/apt/preferences.d/no-debian-php \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
	
# add repo
RUN curl https://download.kopano.io/zhub/z-push:/final/Debian_10/Release.key | gpg --dearmor > /usr/share/keyrings/z-push-archive-keyring.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/z-push-archive-keyring.gpg] https://download.kopano.io/zhub/z-push:/final/Debian_10/ /" > /etc/apt/sources.list.d/zpush.list
	

RUN apt-get update \
	&& apt-get install -y \
	php-soap \
	php-imap \
	z-push-common \
	z-push-config-apache \
	z-push-backend-caldav \
	z-push-backend-carddav \
	z-push-backend-combined \
	z-push-backend-imap \
	z-push-state-sql \
	z-push-autodiscover \
	z-push-ipc-sharedmemory \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
	
ADD entrypoint.sh /srv
RUN chmod +x /srv/entrypoint.sh \
	&& mkdir -p  /var/log/z-push \
	&& chown www-data:www-data /var/log/z-push /usr/share/z-push
ENTRYPOINT /srv/entrypoint.sh
