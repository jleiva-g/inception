*This project has been created as part of the 42 curriculum by jleiva-g.*

# Inception

## Description

Inception is a system administration project focused on Docker and Docker Compose. The goal is to build a small infrastructure composed of separate containers running NGINX, WordPress with PHP-FPM, and MariaDB.

The infrastructure runs inside a virtual machine, with NGINX providing the only external entry point through HTTPS on port 443.

### Services

- **NGINX:** HTTPS entry point using TLS 1.2 or TLS 1.3.
- **WordPress:** Website and PHP-FPM application.
- **MariaDB:** Database for WordPress.

Persistent Docker volumes store the database and website files.

## Project Structure

- `Makefile`: Builds and manages the infrastructure.
- `srcs/docker-compose.yml`: Defines services, networks, volumes, and secrets.
- `srcs/.env`: Stores configuration variables.
- `srcs/requirements/nginx/`: NGINX Dockerfile and configuration.
- `srcs/requirements/wordpress/`: WordPress and PHP-FPM Dockerfile and configuration.
- `srcs/requirements/mariadb/`: MariaDB Dockerfile and configuration.
- `secrets/`: Local secret files, excluded from Git.

## Main Design Choices

### Virtual Machines vs Docker

A virtual machine runs a complete guest operating system. Docker containers share the host kernel and isolate applications with fewer resources.

This project runs Docker inside a virtual machine, as required by the subject.

### Secrets vs Environment Variables

Environment variables are suitable for non-sensitive configuration, such as the domain name and database name. Secrets are preferable for passwords because they can be provided to containers without hardcoding them into Dockerfiles.

### Docker Network vs Host Network

A Docker bridge network allows containers to communicate using service names while isolating their network from the host. Host networking shares the host network namespace and is not used in this project.

### Docker Volumes vs Bind Mounts

Named volumes are managed by Docker and provide persistent storage. Bind mounts map specific host paths into containers.

## Instructions

### Prerequisites

- A virtual machine running a compatible Linux distribution.
- Docker Engine.
- Docker Compose.
- `make`.

### Configuration

1. Set the domain to `jleiva-g.42.fr` in `srcs/.env` and the rest of credentials.
2. Configure the required secrets locally.
3. Ensure the required host storage directory exists under `/home/jleiva-g/data`.
4. Configure the domain to resolve to the virtual machine's IP address.

### Build and Run

From the repository root:

```bash
make
```

Use the targets provided by your Makefile to stop or clean up the infrastructure.

Access the website at:

`https://jleiva-g.42.fr`

## Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- MariaDB documentation: https://mariadb.com/docs/
- PHP documentation: https://www.php.net/docs.php

### AI Usage

AI was used to help interpret the project requirements, explain Docker concepts, review configuration choices, and assist with documentation. Configuration files and commands must be verified and tested by the project author.