FROM aray12/valhalla-docker
MAINTAINER Andrew Ray (Andrew.ray@optum.com)


#RUN axel -a -n 32 -N http://planet.osm.org/pbf/planet-160620.osm.pbf | awk -W interactive '$0~/\[/{printf "%s'$'\r''", $0}'
RUN axel -a -n 32 -N http://download.geofabrik.de/north-america-latest.osm.pbf | awk -W interactive '$0~/\[/{printf "%s'$'\r''", $0}'


RUN mkdir -p /data/valhalla

RUN valhalla_build_admins -c conf/valhalla.json *.pbf
RUN valhalla_build_tiles -c conf/valhalla.json *.pbf


USER daemon

EXPOSE 8002
CMD ["tools/valhalla_route_service", "conf/valhalla.json"]

