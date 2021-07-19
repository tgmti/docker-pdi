#!/bin/bash

## Add  libwebkitgtk repository
echo deb 'http://cz.archive.ubuntu.com/ubuntu bionic main universe' >> /etc/apt/sources.list

## Add repository PUB_KEY
KEYS=$(apt update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p')
echo $KEYS | while read key; do apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$key"; done
