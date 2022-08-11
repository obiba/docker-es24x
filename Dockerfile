FROM obiba/docker-gosu:latest AS gosu

FROM openjdk:8-jre AS server

COPY --from=gosu /usr/local/bin/gosu /usr/local/bin/

# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-repositories.html
# https://www.elastic.co/guide/en/elasticsearch/reference/5.0/deb.html
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*

ENV ELASTICSEARCH_VERSION 2.4.6
ENV ELASTICSEARCH_DEB_VERSION 2.4.6

RUN curl -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.deb

RUN set -x \
	\
# don't allow the package to install its sysctl file (causes the install to fail)
# Failed to write '262144' to '/proc/sys/vm/max_map_count': Read-only file system
	&& dpkg-divert --rename /usr/lib/sysctl.d/elasticsearch.conf \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive dpkg -i elasticsearch-$ELASTICSEARCH_VERSION.deb

ENV PATH /usr/share/elasticsearch/bin:$PATH

WORKDIR /usr/share/elasticsearch

RUN set -ex \
	&& for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

COPY config ./config

VOLUME /usr/share/elasticsearch/data
VOLUME /usr/share/elasticsearch/config

COPY docker-entrypoint.sh /

EXPOSE 9200 9300
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["elasticsearch"]
