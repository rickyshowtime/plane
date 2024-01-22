#!/usr/bin/env bash
cp -f ./space/Dockerfile.space ./
mv Dockerfile.space Dockerfile
mv docker-compose-new.yml docker-compose.yml
docker buildx build . --output type=docker,name=elestio4test/plane-space:latest | docker load