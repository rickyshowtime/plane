#!/usr/bin/env bash
rm .env.example
rm Dockerfile
rm docker-compose.yml
mv .gitignore .gitignore.back
mv .eslintrc.js .eslintrc.js.back
mv package.json package.json.back
mv ./space/README.md ./space/README_back.md
cp -rf ./space/Dockerfile.space ./
mv Dockerfile.api Dockerfile
mv docker-compose-new.yml docker-compose.yml
docker buildx build . --output type=docker,name=elestio4test/plane-space:latest | docker load