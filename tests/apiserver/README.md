<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Plane, verified and packaged by Elestio

[Plane](https://github.com/makeplane/plane) An open-source software development tool to manage issues, sprints, and product roadmaps with peace of mind 🧘‍♀️.

<img src="https://github.com/elestio-examples/plane/raw/main/plane.png" alt="plane" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/plane">fully managed Plane</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/plane/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/plane)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/plane.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:2845`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.8"

    x-api-and-worker-env: &api-and-worker-env
      DEBUG: ${DEBUG}
      SENTRY_DSN: ${SENTRY_DSN}
      DJANGO_SETTINGS_MODULE: plane.settings.production
      DATABASE_URL: postgres://${PGUSER}:${PGPASSWORD}@${PGHOST}:5432/${PGDATABASE}
      REDIS_URL: redis://plane-redis:6379/
      EMAIL_HOST: ${EMAIL_HOST}
      EMAIL_HOST_USER: ${EMAIL_HOST_USER}
      EMAIL_HOST_PASSWORD: ${EMAIL_HOST_PASSWORD}
      EMAIL_PORT: ${EMAIL_PORT}
      EMAIL_FROM: ${EMAIL_FROM}
      EMAIL_USE_TLS: ${EMAIL_USE_TLS}
      EMAIL_USE_SSL: ${EMAIL_USE_SSL}
      AWS_REGION: ${AWS_REGION}
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_S3_BUCKET_NAME: ${AWS_S3_BUCKET_NAME}
      AWS_S3_ENDPOINT_URL: ${AWS_S3_ENDPOINT_URL}
      FILE_SIZE_LIMIT: ${FILE_SIZE_LIMIT}
      WEB_URL: ${WEB_URL}
      GITHUB_CLIENT_SECRET: ${GITHUB_CLIENT_SECRET}
      DISABLE_COLLECTSTATIC: 1
      DOCKERIZED: 1
      OPENAI_API_BASE: ${OPENAI_API_BASE}
      OPENAI_API_KEY: ${OPENAI_API_KEY}
      GPT_ENGINE: ${GPT_ENGINE}
      SECRET_KEY: ${SECRET_KEY}
      DEFAULT_EMAIL: ${DEFAULT_EMAIL}
      DEFAULT_PASSWORD: ${DEFAULT_PASSWORD}
      USE_MINIO: ${USE_MINIO}
      ENABLE_SIGNUP: ${ENABLE_SIGNUP}

    services:
      planefrontend:
        image: elestio4test/plane-space:${SOFTWARE_VERSION_TAG}
        restart: always
        command: /usr/local/bin/start.sh apps/app/server.js app
        env_file:
          - .env
        environment:
          NEXT_PUBLIC_API_BASE_URL: ${NEXT_PUBLIC_API_BASE_URL}
          NEXT_PUBLIC_DEPLOY_URL: ${NEXT_PUBLIC_DEPLOY_URL}
          NEXT_PUBLIC_GOOGLE_CLIENTID: "0"
          NEXT_PUBLIC_GITHUB_APP_NAME: "0"
          NEXT_PUBLIC_GITHUB_ID: "0"
          NEXT_PUBLIC_SENTRY_DSN: "0"
          NEXT_PUBLIC_ENABLE_OAUTH: "0"
          NEXT_PUBLIC_ENABLE_SENTRY: "0"
          NEXT_PUBLIC_ENABLE_SESSION_RECORDER: "0"
          NEXT_PUBLIC_TRACK_EVENTS: "0"
        depends_on:
          - planebackend
          - plane-worker

      planebackend:
        image: elestio4test/plane-apiserver:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/takeoff
        env_file:
          - .env
        environment:
          <<: *api-and-worker-env
        depends_on:
          - plane-db
          - plane-redis

      plane-worker:
        image: elestio4test/plane-apiserver:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/worker
        env_file:
          - .env
        environment:
          <<: *api-and-worker-env
        depends_on:
          - planebackend
          - plane-db
          - plane-redis

      plane-beat-worker:
        image: elestio4test/plane-apiserver:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/beat
        env_file:
          - .env
        environment:
          <<: *api-and-worker-env
        depends_on:
          - planebackend
          - plane-db
          - plane-redis

      plane-db:
        image: elestio/postgres:15
        restart: always
        command: postgres -c 'max_connections=1000'
        volumes:
          - ./pgdata:/var/lib/postgresql/data
        env_file:
          - .env
        ports:
          - 172.17.0.1:2489:5432
        environment:
          POSTGRES_USER: ${PGUSER}
          POSTGRES_DB: ${PGDATABASE}
          POSTGRES_PASSWORD: ${PGPASSWORD}
          PGDATA: /var/lib/postgresql/data

      plane-redis:
        image: elestio/redis:6.0
        restart: always
        volumes:
          - ./redisdata:/data

      plane-minio:
        image: minio/minio
        restart: always
        command: server /export --console-address ":9090"
        volumes:
          - ./uploads:/export
        env_file:
          - .env
        environment:
          MINIO_ROOT_USER: ${AWS_ACCESS_KEY_ID}
          MINIO_ROOT_PASSWORD: ${AWS_SECRET_ACCESS_KEY}

      createbuckets:
        image: minio/mc
        entrypoint: >
          /bin/sh -c " /usr/bin/mc config host add plane-minio http://plane-minio:9000 \$AWS_ACCESS_KEY_ID \$AWS_SECRET_ACCESS_KEY; /usr/bin/mc mb plane-minio/\$AWS_S3_BUCKET_NAME; /usr/bin/mc anonymous set download plane-minio/\$AWS_S3_BUCKET_NAME; exit 0; "
        env_file:
          - .env
        depends_on:
          - plane-minio

      # Comment this if you already have a reverse proxy running
      plane-proxy:
        image: elestio4test/plane-proxy:${SOFTWARE_VERSION_TAG}
        ports:
          - 172.17.0.1:2845:80
        env_file:
          - .env
        environment:
          FILE_SIZE_LIMIT: ${FILE_SIZE_LIMIT:-5242880}
          BUCKET_NAME: ${AWS_S3_BUCKET_NAME:-uploads}
        volumes:
          - ./nginx/nginx.conf:/etc/nginx/nginx.conf
        depends_on:
          - planefrontend
          - planebackend

      pgadmin4:
        image: dpage/pgadmin4:latest
        restart: always
        environment:
          PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
          PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
          PGADMIN_LISTEN_PORT: 8080
        ports:
          - "172.17.0.1:8145:8080"
        volumes:
          - ./servers.json:/pgadmin4/servers.json


# Maintenance

## Logging

The Elestio Plane Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/makeplane/plane">Plane Github repository</a>

- <a target="_blank" href="https://docs.plane.so/">Plane documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/plane">Elestio/plane Github repository</a>
