FROM ubuntu:22.04

WORKDIR /

RUN apt-get update -y
RUN apt-get upgrade -y

# get the app from git
RUN apt-get install -y git
RUN git clone https://github.com/imadki/manapy.git

# install app dependencies
RUN apt-get -y install python3 \
	python3-dev \
	python3-pip \
	libmpich-dev \
	libopenmpi-dev \
	libmumps-ptscotch-dev \
	petsc-dev

RUN python3 -m pip install Cython
RUN python3 -m pip install pytest


WORKDIR /manapy

EXPOSE 8080

# install app
RUN python3 -m pip install .

CMD ["tail", "-f", "/dev/null"]