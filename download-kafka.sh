#!/bin/sh -ex

mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p')
url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
curl "${url}" -o "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
