# internship

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

## Makefile

```
make install
```
This command installs Docker if it doesn't already exist on your system
  - [x] Ubuntu
  - [x] Debian
  - [x] Centos
  - [ ] Rhel
  - [ ] Mac

After ensuring Docker is installed, it proceeds to build the Docker image.

---

```
make run
```
Runs the Docker image that was built previously.

---
```
make terminal
```
 Opens a terminal inside the running container. You’ll have direct access to the container's command line interface.
 
---
 ```
make command COMMAND=<command>
```
Runs a specified command within the container.

Use this command to execute any command inside the container by passing the desired command like make command COMMAND=ls.

---
```
make stop
```
Stops the running container.

---
```
make delete
```
Cleans up the environment by deleting the container and the image built earlier.

---
```
make test
```
Runs the test `python3 -m pytest  manapy -m "not parallel"` within the container

---
