MAKEFLAGS += --silent --ignore-errors

GREEN	= \033[92;1m
RED		= \033[91;1m
RESET	= \033[0m

ifndef DOCKER_IMAGE_NAME
	DOCKER_IMAGE_NAME := manapy_image
endif

ifndef DOCKER_CONTAINER_NAME
	DOCKER_CONTAINER_NAME := manapy_container
endif

all:
	@printf "$(RED)usage: make <rule>$(RESET)\n"

install-docker-linux:
	@printf "\033[0;1minstalling...$(RESET)\n";
	@BASE_OS=$(shell grep '^ID_LIKE=' /etc/os-release | cut -d = -f2); \
	OS=$(shell grep '^ID=' /etc/os-release | cut -d = -f2); \
	if [ "$$BASE_OS" = "debian" ]; then \
		sudo apt-get update -y; \
		sudo apt-get install -y ca-certificates curl; \
		sudo install -m 0755 -d /etc/apt/keyrings; \
		sudo curl -fsSL https://download.docker.com/linux/$$OS/gpg -o /etc/apt/keyrings/docker.asc; \
		sudo chmod a+r /etc/apt/keyrings/docker.asc; \
		echo \
		"deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$$OS \
		$$(. /etc/os-release && echo $${VERSION_CODENAME}) stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null; \
		sudo apt-get update -y; \
		sudo apt-get install -y docker-ce; \
	elif [ "$$BASE_OS" = "fedora" ]; then \
		sudo dnf -y update; \
		sudo dnf -y install dnf-plugins-core; \
		sudo dnf config-manager --add-repo https://download.docker.com/linux/$$OS/docker-ce.repo; \
		sudo dnf -y install containerd.io docker-ce; \
	else \
		printf "$(RED)> Error installing Docker Please install it manually.$(RESET)\n"; \
	fi
	@sudo systemctl enable --now docker;
	@sudo usermod -aG docker $$USER;

install-docker-mac:
	@printf "\033[0;1minstalling...$(RESET)\n"
	@sudo hdiutil attach Docker.dmg
	@sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
	@sudo hdiutil detach /Volumes/Docker

check-requirements:
	@command -v docker >/dev/null 2>&1 || (printf "$(RED)> Docker is not installed.$(RESET)\n"; \
	OS_NAME=$(shell uname -s) && \
		if [ "$$OS_NAME" = "Linux" ]; then \
			make install-docker-linux;		 \
		elif [ "$$OS_NAME" = "Darwin" ]; then \
			make install-docker-mac;		\
		fi; \
	(command -v docker >/dev/null 2>&1 && \
		printf "$(GREEN)> Docker is installed.$(RESET)\n" || \
		printf "$(RED)> Error installing Docker Please install it manually.$(RESET)\n" ))

install: check-requirements
	@docker build -t $(DOCKER_IMAGE_NAME) .

run:
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

.PHONY: all install run check-requirements install-docker-linux install-docker-mac terminal stop delete test command
