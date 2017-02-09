# Dockerfile for Valhalla
Cloned from https://github.com/valhalla/valhalla-docker
---


To build the Docker image issue:

```sh
./build.sh
```

To run instead issue:

```sh
./run-valhalla.sh
```

note in order to get this stuff to run i needed more memory, i know it works with 100GB swap, re-running now to see if it can run in 24g
```sh
sudo fallocate -l 24G /dockerdata/tempswap
sudo chmod 666 /dockerdata/tempswap
175  sudo mkswap /dockerdata/tempswap
176  sudo swapon /dockerdata/tempswap
```
