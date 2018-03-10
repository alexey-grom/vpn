#!/usr/bin/env bash

. ./.config.sh

if [ -z "$1" ]; then
  echo "username is required"
  exit
fi

username=$1
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $username > configs/$username.ovpn
