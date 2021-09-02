FROM opendronemap/odm:latest
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000

USER root
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
    apt-get install -y \
	cmake \
	gdal-bin \
	git \
	libboost-dev \
	libboost-program-options-dev \
    libgdal-dev \
	libpq-dev \
	nodejs \
	npm \
	python3-gdal

RUN npm install -g nodemon

# Build LASzip and PotreeConverter
WORKDIR "/staging"
RUN git clone https://github.com/pierotofy/LAStools /staging/LAStools && \
	cd LAStools/LASzip && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release .. && \
	make

RUN mkdir /var/www

WORKDIR "/var/www"

RUN git clone https://github.com/OpenDroneMap/NodeODM .

COPY . /var/www

RUN npm install

ENTRYPOINT ["/usr/bin/nodejs", "/var/www/index.js"]
