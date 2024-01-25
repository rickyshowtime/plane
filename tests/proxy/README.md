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

You can access the Web UI at: `http://your-domain:4000`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.8"

    services:
      web:
        image: elestio4test/plane-frontend
        restart: always
        command: /usr/local/bin/start.sh web/server.js web
        depends_on:
          - api
          - worker

      space:
        image: elestio4test/plane-space
        restart: always
        command: /usr/local/bin/start.sh space/server.js space
        depends_on:
          - api
          - worker
          - web

      api:
        image: elestio4test/plane-backend:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/takeoff
        env_file:
          - .env
        depends_on:
          - plane-db
          - plane-redis

      worker:
        image: elestio4test/plane-backend:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/worker
        env_file:
          - .env
        depends_on:
          - api
          - plane-db
          - plane-redis

      beat-worker:
        image: elestio4test/plane-backend:${SOFTWARE_VERSION_TAG}
        restart: always
        command: ./bin/beat
        env_file:
          - .env
        depends_on:
          - api
          - plane-db
          - plane-redis

      plane-db:
        container_name: plane-db
        image: postgres:15.2-alpine
        restart: always
        command: postgres -c 'max_connections=1000'
        volumes:
          - pgdata:/var/lib/postgresql/data
        env_file:
          - .env
        environment:
          POSTGRES_USER: ${PGUSER}
          POSTGRES_DB: ${PGDATABASE}
          POSTGRES_PASSWORD: ${PGPASSWORD}
          PGDATA: /var/lib/postgresql/data

      plane-redis:
        container_name: plane-redis
        image: redis:6.2.7-alpine
        restart: always
        volumes:
          - redisdata:/data

      plane-minio:
        container_name: plane-minio
        image: minio/minio
        restart: always
        command: server /export --console-address ":9090"
        volumes:
          - uploads:/export
        environment:
          MINIO_ROOT_USER: ${AWS_ACCESS_KEY_ID}
          MINIO_ROOT_PASSWORD: ${AWS_SECRET_ACCESS_KEY}

      # Comment this if you already have a reverse proxy running
      proxy:
        image: elestio4test/plane-proxy
        restart: always
        ports:
          - 172.17.0.1:4000:80
        environment:
          FILE_SIZE_LIMIT: ${FILE_SIZE_LIMIT:-5242880}
          BUCKET_NAME: ${AWS_S3_BUCKET_NAME:-uploads}
        depends_on:
          - web
          - api
          - space

    volumes:
      pgdata:
      redisdata:
      uploads:



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
