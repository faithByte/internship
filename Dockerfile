FROM python:3.13-bullseye

RUN apt-get update -y &&\
	python3 -m pip install --upgrade pip setuptools wheel && \
	python3 -m pip install Cython pytest && \
	apt install -y libmpich12 libmpich-dev \
	libopenmpi3 libopenmpi-dev && \
	# libmumps-ptscotch libmumps-ptscotch-dev \
	# petsc petsc-dev && \
	git clone https://github.com/imadki/manapy.git && \
	python3 -m pip install  manapy/
	
RUN	apt-get remove --purge -y \
	libmpich-dev  \
	libopenmpi-dev && \
	# libmumps-ptscotch-dev \
	# petsc-dev && \
	apt-get -y autoremove --purge && \
	apt-get clean
CMD ["tail", "-f", "/dev/null"]