# TomaRamosUandes

Non-official mobile-focused web application for dealing with the messy course inscription (AKA *toma de ramos*) process at Universidad de los Andes, Chile.

- [TomaRamosUandes](#tomaramosuandes)
  - [1. Main features](#1-main-features)
  - [2. Architecture](#2-architecture)
  - [3. Contributing](#3-contributing)
  - [4. Developing](#4-developing)
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

<!-- TODO --> TODO

## 2. Architecture

This application is deployed virtualized on docker-compose with the following services:

<!-- TODO --> TODO

## 3. Contributing

Please head to the [`docs`](./docs/) directory and read the [contributing docs](./docs/CONTRIBUTING.md).

## 4. Developing

Please review [`docs/developing.md`](./docs/developing.md).

## 5. Usage

### 5.1. First run

Before anything, as the virtualized database (Docker container) is preserved via a volume mount, this data has first to exist in the host machine, i.e., the mounted directory, `postgres-data`, has to be filled with the minimum files for a blank PostgreSQL server to work.

A clumsy way to do this is:

1. Comment the `volume` statement for the postgres service at [`docker-compose.yaml`](./docker-compose.yaml).
2. Run `docker-compose up --build tomaramos-postgres` for starting the database container only.
3. From another terminal, create the `postgres-data` directory with `mkdir postgres-data`.
4. Copy the blank postgres data files from the container into the `postgres-data` directory in your host machine with `docker cp tomaramos-postgres-container:/var/lib/postgresql/${POSTGRES_VERSION}/main/ ./postgres-data`, where `POSTGRES_VERSION` is defined in the [`.env`](./.env) file.
5. Undo step (1).

### 5.2. Build and run

Simply run the environment with docker-compose, for instance, with:

```shell
docker-compose down --remove-orphans && docker-compose up --build
```

As the database is preserved due the volume mount, restarting all containers will not erase the database, which is intended for virtualized deployment.

## 6. Testing

### 6.1. Virtualized

Considering the environment is already up and running, you can execute rails tests with:

```shell
docker exec tomaramos-rails-container rails test
```

### 6.2. Local

If you have the Rails app dependencies installed and set-up in your machine, you can directly cd into `TomaRamosWebApp` and run `rails test`, or `make test`.
