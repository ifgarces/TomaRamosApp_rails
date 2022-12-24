# TomaRamosApp

Non-official mobile-focused web application for helping students plan their course inscription process (AKA *toma de ramos*) at Universidad de los Andes, Chile. Please visit the project's landing page at [`TomaRamos.App`](https://tomaramos.app) for more information.

- [TomaRamosApp](#tomaramosapp)
  - [1. Main features](#1-main-features)
  - [2. Architecture](#2-architecture)
  - [Project structure](#project-structure)
  - [3. Contributing](#3-contributing)
  - [5. Usage](#5-usage)
    - [5.1. First run](#51-first-run)
    - [5.2. Build and run](#52-build-and-run)
  - [6. Testing](#6-testing)
    - [6.1. Virtualized](#61-virtualized)
    - [6.2. Local](#62-local)

## 1. Main features

- Automatic building of the displayable weekly schedule of the inscribed courses.
- Download week schedule as image.
- Parsing of the courses catalog provided by the Faculty (as CSV).
- Detection of conflicts between courses when inscribing, including evaluations.

## 2. Architecture

This application is deployed virtualized on docker-compose with the following services:

- `tomaramos-postgres`: PostgreSQL database server.
- `tomaramos-rails`: Ruby on Rails framework with the actual web application.
- `html-to-image`: microservice utility used by `tomaramos-rails` for exporting an user's week schedule as image.

![Docker architecture diagram](./docs/architecture-docker.png)

## Project structure

| Directory         | Description                                                               |
| ----------------- | ------------------------------------------------------------------------- |
| `.vscode`         | Contains project-related IDE configuration (for Visual Studio Code).      |
| `docs`            | Documentation resources.                                                  |
| `postgres-volume` | Shared Docker volume with the database. See section [5.1](#51-first-run). |
| `HTMLToImage`     | Docker microservice for converting HTML+CSS into an image.                |
| `PostgresDB`      | Docker service with the database server (DBMS).                           |
| `TomaRamosWebApp` | Source code of the Ruby on Rails web application.                         |

## 3. Contributing

Please head to the [`docs`](./docs/) directory and read the [contributing docs](./docs/contributing.md).

## 5. Usage

### 5.1. First run

Before anything, as the virtualized database (Docker container) is preserved via a volume, this data has first to exist in the host machine, i.e., the mounted directory, `postgres-volume`, has to be filled with the minimum files for a blank PostgreSQL server to work.

A clumsy way to do this is:

1. Comment the `volume` statement for the postgres service at [`docker-compose.yaml`](./docker-compose.yaml).
2. Run `docker-compose up --build tomaramos-postgres` for starting the database container only.
3. From another terminal, create the `postgres-volume` directory with `mkdir postgres-volume`, in your host machine.
4. Copy the blank postgres data files from the container into the `postgres-volume` directory in your host machine with `docker cp tomaramos-postgres-container:/var/lib/postgresql/${POSTGRES_VERSION}/main/ ./postgres-volume`, where `POSTGRES_VERSION` is defined in the [`.env`](./.env) file.
5. Undo step (1).

Also, it is mandatory to create a `.secrets.env` file with sensitive environment variables. The following command will create a template. The only mandatory variable for running the environment (outside Docker) is `ADMIN_USER_PASSWORD`.

```shell
echo "
ADMIN_USER_PASSWORD=fooPassword
OAUTH_CLIENT_ID=
OAUTH_CLIENT_SECRET=
" > .secrets.env
```

### 5.2. Build and run

Simply run the environment with docker-compose, for instance, with:

```shell
docker-compose down --remove-orphans && docker-compose up --build
```

As the database is preserved due the volume mount, restarting all containers will not erase the database, which is intended for virtualized deployment.

## 6. Testing

### 6.1. Virtualized

Considering the environment is already up and running, an interactive shell for the Rails container can be launched with:

```shell
docker exec -it tomaramos-rails-container /bin/bash
```

Then, for correctly running Rails tests, the following command has to be executed within that shell instance:

```shell
DATABASE_URL="postgresql://tomaramosuandes:tomaramosuandes@tomaramos-postgres:${POSTGRES_PORT}/tomaramosuandes_test" rails test
```

### 6.2. Local

If you have the Rails app dependencies installed and set-up in your machine, you can directly cd into `TomaRamosWebApp` and run `rails test`, or `make test`.
