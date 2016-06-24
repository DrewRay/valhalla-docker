FROM ubuntu:trusty
MAINTAINER Andrew Ray (Andrew.ray@optum.com)

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y git \
  libtool \
  automake \
  pkg-config \
  libcurl4-gnutls-dev \
  sudo \
  build-essential \
  libboost1.54-all-dev \
  software-properties-common \
  axel
  

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/mjolnir.git && \
  cd mjolnir && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/tools.git && \
  cd tools && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

#ADD ./conf /conf
RUN git clone \
    --depth=1 \
    --recurse-submodules \
    --single-branch \
    --branch=master https://github.com/valhalla/conf.git

RUN ldconfig

#RUN wget --progress=dot:mega https://s3.amazonaws.com/metro-extracts.mapzen.com/minneapolis-saint-paul_minnesota.osm.pbf 
#RUN wget --progress=dot:giga http://download.geofabrik.de/north-america-latest.osm.pbf
run axel -a -n 8 -N http://planet.osm.org/pbf/planet-160620.osm.pbf



RUN mkdir -p /data/valhalla
RUN valhalla_build_admins -c conf/valhalla.json *.pbf
RUN valhalla_build_tiles -c conf/valhalla.json *.pbf

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER daemon

EXPOSE 8002
CMD ["tools/valhalla_route_service", "conf/valhalla.json"]

