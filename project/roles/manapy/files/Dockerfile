FROM python:3.13-bullseye

RUN apt-get update -y &&\
	python3 -m pip install --upgrade pip setuptools wheel && \
	python3 -m pip install Cython pytest && \
	apt install -y libmpich12 libmpich-dev \
	libopenmpi3 libopenmpi-dev && \
	git clone https://github.com/imadki/manapy.git && \
	python3 -m pip install manapy/ && \
	apt-get remove --purge -y \
	libmpich-dev  \
	libopenmpi-dev && \
	apt-get -y autoremove --purge && \
	apt-get clean && \
	apt-get install petsc-dev -y && \
	python3 -m pip install petsc petsc4py

ENV MESH_DIR="/manapy/mesh"

CMD ["tail", "-f", "/dev/null"]