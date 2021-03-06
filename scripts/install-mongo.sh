#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_MONGO $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$INSTALL_MONGO" = true ]; then
  printf "\n[-] Installing MongoDB ${MONGO_VERSION}...\n\n"

  apt-get install dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
  echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list

	apt-get update

  apt-get install -y \
    ${MONGO_PACKAGE}=$MONGO_VERSION \
    ${MONGO_PACKAGE}-server=$MONGO_VERSION \
    ${MONGO_PACKAGE}-shell=$MONGO_VERSION \
    ${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
    ${MONGO_PACKAGE}-tools=$MONGO_VERSION

  mkdir -p /data/{db,configdb}
  chown -R mongodb:mongodb /data/{db,configdb}

	rm -rf /var/lib/apt/lists/*
	rm -rf /var/lib/mongodb
  mv /etc/mongod.conf /etc/mongod.conf.orig

fi
