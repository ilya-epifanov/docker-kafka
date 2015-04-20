FROM debian:wheezy

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

RUN apt-get update && apt-get install -y curl ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

RUN groupadd -r kafka && useradd -r -d /var/lib/kafka -m -g kafka kafka

RUN apt-get update &&\
    apt-get install -y openjdk-7-jre-headless --no-install-recommends &&\
    dpkg-reconfigure ca-certificates-java &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SCALA_VERSION=2.10 KAFKA_VERSION=0.8.2.1

COPY download-kafka.sh /tmp/
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt
RUN ln -sfT /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

ENV PATH /opt/kafka/bin:$PATH

RUN mkdir /opt/kafka/data

VOLUME /opt/kafka/config /opt/kafka/data /opt/kafka/logs

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9092
CMD ["kafka-server-start.sh", "/opt/kafka/config/server.properties"]
