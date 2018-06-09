#!/usr/bin/env bash

. ./.config.sh

function get-ip () {
  config=$1
  filename=/etc/openvpn/client/$config.conf
  cat $filename | grep "remote " | awk '{ print $2 }'
}

files=$( cd /etc/openvpn/client/ && find . -type f -name "*.conf" )
files=$(basename -a -s .conf $files)

current=$( cd /etc/systemd/ && find . -name "openvpn-client@*.service" | head -1 )
if [ ! -z "$current" ]; then
  current=$( basename -s .service $current | sed -e "s/.*@//" )
  echo "Current config: $current ($(get-ip $current))"
  echo "systemd status:"
  systemctl | grep openvpn-client@${current}
  echo
fi

for item in ${files[@]}; do
  printf "%-17s %s\n" $(get-ip $item) $item
done
echo

echo "Select a new config:"
select FILENAME in $files; do
  if [ ! -z "$FILENAME" ]; then
    echo "You picked $FILENAME"
    if [ ! -z "$current" ]; then
      echo "Disable ${current}"
      sudo systemctl disable openvpn-client@${current}
      sudo systemctl stop openvpn-client@${current}
    fi
    echo "Enable ${FILENAME}"
    sudo systemctl enable openvpn-client@${FILENAME}
    sudo systemctl restart openvpn-client@${FILENAME}
    systemctl status openvpn-client@${FILENAME}
    break
  fi
done
