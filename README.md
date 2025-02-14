# internship

The following is designed to work on Debian 12 systems.

```
git clone https://github.com/faithByte/internship.git
cd ./internship
./script.sh
```

## Makefile
This project includes a Makefile that automates common tasks  
No need to worry about it, it's just here to make my life easier! 😅


## script.sh
This script is the only thing you need to run to set up the project. It will check if ansible is installed, if it's not, it installs it, and then it will execute the playbook to set up the project.

## playbook.yml + variables.ini
This playbook installs docker on the targeted machines if it's not already installed, builds the docker image, and then runs the container.

## Basic docker commands
```
docker build -t <DOCKER_IMAGE_NAME> .
```

```
docker run -d --name <DOCKER_CONTAINER_NAME> <DOCKER_IMAGE_NAME>
```

```
docker exec -it <DOCKER_CONTAINER_NAME> /bin/bash
```
