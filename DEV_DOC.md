# Developer Documentation

## Prerequisites

Install the following inside the virtual machine:

- Docker Engine
- Docker Compose plugin
- GNU Make
- Git

## Repository Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        ├── wordpress/
        └── mariadb/
```

## Configuration

Edit `srcs/.env` to configure the domain name and required application settings.

Create the secret files expected by `docker-compose.yml` under `secrets/`. Do not commit passwords or other sensitive information.


## Building and Launching

From the repository root:

```bash
make
```

The Makefile should invoke Docker Compose to build the custom images and start the services.

You can also run Compose directly:

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f srcs/docker-compose.yml up -d --build
```

## Container Management

List containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Stop the services:

```bash
docker compose -f srcs/docker-compose.yml down
```

Rebuild images:

```bash
docker compose -f srcs/docker-compose.yml build --no-cache
```

## Volumes and Persistence

The project requires two named volumes:

- `mariadb_data`: database files mounted at `/var/lib/mysql`.
- `wordpress_data`: WordPress files mounted at `/var/www/html`.

The subject requires their host storage to be under `/home/jleiva-g/data`.

Inspect volumes:

```bash
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

## Network

The services communicate over the Compose bridge network named `inception`. Containers can reach one another using their service names.

Only NGINX should publish port 443 to the host.

## Troubleshooting

Check the resolved Compose configuration:

```bash
docker compose -f srcs/docker-compose.yml config
```

Inspect logs for startup or connection errors:

```bash
docker compose -f srcs/docker-compose.yml logs nginx wordpress mariadb
```

Verify the `.env` file, secret paths, file permissions, network configuration, and volume mounts when a service fails to start.