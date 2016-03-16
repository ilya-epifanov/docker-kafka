FROM java:8-jre

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

# https://kafka.apache.org/downloads.html
ENV KAFKA_VERSION 0.9.0.1
ENV SCALA_VERSION 2.11

ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh \
 && tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /usr/local \
 && ln -sfT /usr/local/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /usr/local/kafka \
 && rm -Rf /tmp/*

WORKDIR /usr/local/kafka
ENV PATH $PATH:/usr/local/kafka/bin

RUN sed -i 's!^zookeeper.connect=.*!zookeeper.connect=zookeeper:2181!' config/server.properties

CMD ["kafka-server-start.sh", "config/server.properties"]
