# vice-node-odm
VICE deployment of OpenDroneMap node API

## GitHub Action

Pushes the container to CyVerse Harbor private container registry

## Test builds locally

To build your own container from Docker:

```
docker build -t nodeodm:latest .
```

To run with Docker locally:

```
docker run -it -p 3000:3000 --rm nodeodm:latest 
```
