#!/usr/bin/env bash

. ./.config.sh

docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn chown -R $(id -u):$(id -g) /etc/openvpn/
