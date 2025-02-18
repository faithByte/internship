#!/bin/bash
# debian 12

RED="\033[91;1m"
GREEN="\033[92;1m"
RESET="\033[0m"

if [ -z "$PLAYBOOK" ]; then
	PLAYBOOK=$(ls *.yml)
fi


if !(which ansible > /dev/null); then
	printf "$RED> Ansible is not installed.$RESET\n";
	printf "\033[0;1minstalling...$RESET\n";
	sudo apt update -y;
	sudo apt-get install -y ansible && printf "$GREEN> Ansible is installed.$RESET\n" || (printf "$$RED> Error installing ansible.$RESET\n" && exit 1);
fi

ansible-playbook $PLAYBOOK;