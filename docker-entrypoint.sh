#!/bin/bash
set -e

if [ "$1" == 'kafka-server-start.sh' ]; then
	mkdir -p -m a=rx,u+w /opt/kafka/{logs,data}
	chown -R kafka /opt/kafka/{logs,data}
	set -- gosu kafka "$@"
fi

exec "$@"
