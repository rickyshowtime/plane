#!/usr/bin/env bash
rm .env.example
rm Dockerfile
rm docker-compose.yml
mv .eslintrc.js .eslintrc.js.back
mv package.json package.json.back
cp -rf ./web/* ./
mv Dockerfile.web Dockerfile
mv docker-compose-new.yml docker-compose.yml

docker buildx build . --output type=docker,name=elestio4test/plane-frontend:latest | docker load