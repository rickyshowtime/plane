#!/usr/bin/env bash
rm .env.example
rm Dockerfile
rm docker-compose.yml
cp -rf ./apiserver/* ./
mv Dockerfile.api Dockerfile
mv docker-compose-new.yml docker-compose.yml
docker buildx build . --output type=docker,name=elestio4test/plane-apiserver:latest | docker load