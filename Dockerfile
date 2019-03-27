FROM ubuntu:16.04

RUN apt-get install -y libboost-dev libboost-program-options-dev git

RUN mkdir /staging \
    && git clone https://github.com/pierotofy/LAStools /staging/LAStools \
    && cd LAStools/LASzip \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make

RUN git clone https://github.com/pierotofy/PotreeConverter /staging/PotreeConverter \
    && cd /staging/PotreeConverter \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/staging/LAStools/LASzip/dll -DLASZIP_LIBRARY=/staging/LAStools/LASzip/build/src/liblaszip.a .. \
    && make && sudo make install \

# 2) Install gdal2tiles.py script, node.js and npm dependencies

RUN curl --silent --location https://deb.nodesource.com/setup_6.x | sudo bash - \
    && apt-get install -y nodejs python-gdal \
    && git clone https://github.com/OpenDroneMap/NodeODM \
    && cd NodeODM \ 
    && npm install 
    
USER node-odm     

CMD mkdir -p /home/node-odm/OpenDroneMap

ENTRYPOINT "node index.js --odm_path /home/node-odm/OpenDroneMap"
