MAKEFLAGS += --silent --ignore-errors

RED		= \033[91;1m
GREEN	= \033[92;1m
RESET	= \033[0m

ifndef INVENTORY
	INVENTORY = $(shell ls *.ini | paste -sd, -)
endif

ifndef PLAYBOOK
	PLAYBOOK = *.yml
endif

ifndef DOCKER_IMAGE_NAME
	DOCKER_IMAGE_NAME := manapy_image
endif

ifndef DOCKER_CONTAINER_NAME
	DOCKER_CONTAINER_NAME := manapy_container
endif

## vagrant
vm:
	vagrant up
	vagrant ssh

## ansible
all:
	@echo $(PLAYBOOK)
	@echo $(INVENTORY)



run: checkAnsibleInstalled
	@ansible-playbook -i $(INVENTORY) $(PLAYBOOK);


checkAnsibleInstalled:
	@which ansible > /dev/null 2>&1 || { printf "$(RED)> Ansible is not installed.$(RESET)\n"; make install; }

install:
	@printf "\033[0;1minstalling...$(RESET)\n";
	@sudo apt update -y
	@sudo apt-get install -y ansible
	@printf "$(GREEN)> Ansible is installed.$(RESET)\n"


## docker
task:
	@ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --start-at-task="$(TASK)"

runContainer:
	@docker run -d --name $(DOCKER_CONTAINER_NAME) $(DOCKER_IMAGE_NAME)

terminal:
	@docker exec -it $(DOCKER_CONTAINER_NAME) /bin/bash

test:
	@docker exec -it $(DOCKER_CONTAINER_NAME) python3 -m pytest  manapy -m "not parallel"

command:
	@if [ -z "$(COMMAND)" ]; then \
		echo "$(RED)usage:\tmake command COMMAND=\"your command\"$(RESET)"; \
	else \
		docker exec -it $(DOCKER_CONTAINER_NAME) $(COMMAND); \
	fi

stop:
	@docker stop $(DOCKER_CONTAINER_NAME)

delete: stop
	@docker rm -f $(DOCKER_CONTAINER_NAME)
	@docker rmi -f $(DOCKER_IMAGE_NAME)

.PHONY: all install run checkAnsibleInstalled task runContainer terminal test command stop delete