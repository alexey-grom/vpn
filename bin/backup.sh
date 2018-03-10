#!/usr/bin/env bash

. ./.config.sh

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn tar -cvf - -C /etc openvpn | xz > openvpn-backup.tar.xz