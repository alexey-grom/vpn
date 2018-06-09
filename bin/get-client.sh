#!/usr/bin/env bash

. ./.config.sh

OPTIND=1
install=
while getopts "i" opt; do
  case $opt in
    i)
      install=1
      ;;
    *)
      ;;
  esac
done
shift "$((OPTIND-1))"

if [ -z "$1" ]; then
  echo "username is required"
  exit
fi

username=$1
pure_config=configs/$username.ovpn

echo "Getting a pure config for $username and save to $pure_config..."
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $username > $pure_config
echo

function get-ip-for-hostname () {
  hostname=$1
  ssh -G $hostname 2>/dev/null | awk '/^hostname / { print $2 }'
}

function processing () {
  hostname=$1
  address=$(get-ip-for-hostname $hostname)
  echo "Processing a config for hostname $hostname with address $address"
  host_config="configs/$username--$hostname.ovpn"
  cat $pure_config | sed -e "s/remote vpn/remote $address/g" > $host_config
  echo "Config for $hostname is saved to $host_config"
  if [ ! -z $install ]; then
    echo "Copy to /etc/openvpn/client/"
    sudo cp $host_config /etc/openvpn/client/$username--$hostname.conf
  fi
  echo
}

echo "Generating configs for hosts..."
echo
while read line; do
  hostname=$line
  if [[ ! "$line" =~ ^\; ]]; then
    processing $line
  fi
done <deploy-vpn.ini
