FROM aray12/valhalla-docker:Base
MAINTAINER Andrew Ray (Andrew.ray@optum.com)


RUN axel -a -n 32 -N http://planet.osm.org/pbf/planet-160620.osm.pbf

#RUN axel -a -n 32 -N https://s3.amazonaws.com/metro-extracts.mapzen.com/duluth_minnesota.osm.pbf

RUN mkdir -p /data/valhalla

RUN valhalla_build_admins -c conf/valhalla.json *.pbf
RUN valhalla_build_tiles -c conf/valhalla.json *.pbf

USER daemon

EXPOSE 8002
CMD ["tools/valhalla_route_service", "conf/valhalla.json"]
