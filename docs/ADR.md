---
output: pdf_document
---
# SoftwareArchitecture — Assignment 3: Architecture Decision Records

> Ignacio F. Garcés
>
> Universidad de los Andes
>
> 2022

- [SoftwareArchitecture — Assignment 3: Architecture Decision Records](#softwarearchitecture--assignment-3-architecture-decision-records)
  - [1. Exclusively server-client architecture (web application)](#1-exclusively-server-client-architecture-web-application)
    - [1.1. Status](#11-status)
    - [1.2. Context](#12-context)
    - [1.3. Decision](#13-decision)
    - [1.4. Consequences](#14-consequences)
  - [2. Ruby on Rails as framework for the web application](#2-ruby-on-rails-as-framework-for-the-web-application)
    - [2.1. Status](#21-status)
    - [2.2. Context](#22-context)
    - [2.3. Decision](#23-decision)
    - [2.4. Consequences](#24-consequences)
  - [3. Virtualization runtime with docker-compose](#3-virtualization-runtime-with-docker-compose)
    - [3.1. Status](#31-status)
    - [3.2. Context](#32-context)
    - [3.3. Decision](#33-decision)
    - [3.4. Consequences](#34-consequences)
  - [4. Appendix: references](#4-appendix-references)

## 1. Exclusively server-client architecture (web application)

### 1.1. Status

Implemented.

### 1.2. Context

In order to maximize user experience, facilitating the usage of the solution, it is mandatory for this project to be a full web application, without any kind of installation required for the user. Also, focused on mobile devices, as the target users are young adults and heavy smartphone users.

### 1.3. Decision

Developing the solution as a full web application most effective way for a small project like this, for both the developers and users, as it eases usages, being natively multi-platform, and not needing to be properly licensed and published in application stores (e.g. Google Play) to reach the users' devices.

### 1.4. Consequences

As we won't be able to access to the device's storage for storing data, this will require a more complex model architecture for storing the user's data (e.g. inscribed courses) on the server. With this, implementing features such as touch gestures, for instance, if desired, will become very difficult, in contrast with a native (installed) mobile application.

## 2. Ruby on Rails as framework for the web application

### 2.1. Status

Implemented.

### 2.2. Context

There are many programming languages and frameworks for developing a simple web application of this kind, with different features. Ruby on Rails is one of the most popular frameworks due its great support, high-standard native security measures, robust architecture (MVC) and code generators for easing development, among other features.

### 2.3. Decision

The following table shows the candidates that were considered as frameworks for the project.

| Framework name      | Backend programming language | Built-in security |
| ------------------- | ---------------------------- | ----------------- |
| Django              | Python                       | Medium            |
| Ruby on Rails (RoR) | Ruby                         | High              |
| ExpressJS           | JavaScript / Typescript      | Low               |

Django is a modern framework with good reputation, but lacks of Rails' high security measures and lacks of code generators similar to Rails'. ExpressJS was discarded immediately, as it is a lightweight framework compared to the others, and does not have many features. Besides, Rails has a convenient way to handle database models in code.

### 2.4. Consequences

Despite its advantages, RoR can be difficult and confusing for developers, specially those with no experience in Rails. However, this framework will facilitate the development of a robust web application with high industry standards.

## 3. Virtualization runtime with docker-compose

### 3.1. Status

Implemented.

### 3.2. Context

It may be needed to migrate the deployment server (e.g. between different Cloud Computing hosting services), which is much easier if the application is virtualized.

### 3.3. Decision

Instead of a native runtime of the application in the deployment server, have it running virtualized, as Docker containers. This will require the creation of Docker-related scripts for automating the runtime environment.

### 3.4. Consequences

Having the application virtualized will greatly ease the migration in any moment, as well as the development, allowing developers to run the system in their machines with a single command, thanks to Docker and docker-compose. Also, this provides more transparency on the dependencies of the project and allows developers to be aware of them easier. However, adding different services, dependencies, etc. may require updating Dockerfile, docker-compose and related code.

## 4. Appendix: references

Lasselsberger, S n.d., *Architecture Decision Records Example*, Lasssim, viewed 1 October 2022, <https://www.lasssim.com/architecture-decision-records-example/>.
