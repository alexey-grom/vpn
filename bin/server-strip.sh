#!/usr/bin/env bash

. ./.config.sh

docker run --rm -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn ovpn_copy_server_files
docker run --rm -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn chown -R $(id -u):$(id -g) /etc/openvpn/server/
docker run --rm -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn tar -cvf - -C /etc/openvpn server | xz > openvpn-server-strip.tar.xz
docker run --rm -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn rm -r /etc/openvpn/server/
