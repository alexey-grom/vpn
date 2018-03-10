#!/usr/bin/env bash

. ./.config.sh

if [ -z "$1" ]; then
  echo "username is required"
  exit
fi

username=$1
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $username nopass
./bin/fix-permissions.sh
./bin/get-client.sh $username
