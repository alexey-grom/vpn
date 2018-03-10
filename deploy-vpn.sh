#!/usr/bin/env bash

ansible-playbook -i deploy-vpn.ini playbooks/deploy-vpn.yml --tags="${@:-all}"
