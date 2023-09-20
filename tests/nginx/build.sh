#!/usr/bin/env bash
rm .env.example
rm Dockerfile
rm docker-compose.yml
cp -rf ./nginx/* ./
mv docker-compose-new.yml docker-compose.yml

docker buildx build . --output type=docker,name=elestio4test/plane-proxy:latest | docker load