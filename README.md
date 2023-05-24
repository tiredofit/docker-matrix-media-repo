# github.com/tiredofit/docker-matrix-media-repo

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-matrix-media-repo?style=flat-square)](https://github.com/tiredofit/docker-matrix-media-repo/releases)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-matrix-media-repo/build?style=flat-square)](https://github.com/tiredofit/docker-matrix-media-repo/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/matrix-media-repo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/matrix-media-repo/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/matrix-media-repo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/matrix-media-repo/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [Matrix Media Repo](https://github.com/turt2live/matrix-media-repo), A deduplicating media repository for Matrix Homeservers.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Database Options](#database-options)
    - [Access Tokens and Appservices](#access-tokens-and-appservices)
    - [Repository Options](#repository-options)
    - [Networking Options](#networking-options)
    - [Homeserver Options](#homeserver-options)
    - [Federation Options](#federation-options)
    - [Download and Upload Limits](#download-and-upload-limits)
    - [Metrics Options](#metrics-options)
    - [Datastore Options](#datastore-options)
    - [URL Previews Options](#url-previews-options)
    - [Quarantine Options](#quarantine-options)
    - [Thumbnail Options](#thumbnail-options)
    - [Plugin Options](#plugin-options)
    - [Blurhash Options](#blurhash-options)
    - [Rate Limiting](#rate-limiting)
    - [Redis Options](#redis-options)
    - [Sentry Options](#sentry-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)


## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Needs access to a Postgresql database
*  Optional access to a Redis Server


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/matrix-media-repo).

```
docker pull tiredofit/matrix-media-repo:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/matrix-media-repo/pkgs/container/matrix-media-repo)

```
docker pull ghcr.io/tiredofit/docker-matrix-media-repo:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
| --------- | ----------- |


* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


#### Container Options
| Variable          | Value | Default                                 |
| ----------------- | ----- | --------------------------------------- |
| `CONFIG_PATH`     |       | `/config/`                              |
| `CONFIG_FILE`     |       | `media-repo.yaml`                       |
| `DATA_PATH`       |       | `/data/`                                |
| `MEDIA_PATH`      |       | `${DATA_PATH}/media/`                   |
| `MIGRATIONS_PATH` |       | `/assets/matrix-media-repo/migrations/` |
| `ASSETS_PATH`     |       | `/assets/matrix-media-repo/assets/`     |
| `TEMPLATES_PATH`  |       | `/assets/matrix-media-repo/templates/`  |
| `LOG_TYPE`        |       | `FILE`                                  |
| `LOG_LEVEL`       |       | `info`                                  |
| `LOG_PATH`        |       | `/logs/`                                |
| `LOG_COLOURS`     |       | `false`                                 |
| `LOG_JSON`        |       | `TRUE`                                  |
| `SETUP_MODE`      |       | `AUTO`                                  |

#### Database Options

| Variable                   | Description                     | Default |
| -------------------------- | ------------------------------- | ------- |
| `DB_POOL_CONNECTIONS_MAX`  |                                 | `25`    |
| `DB_POOL_CONNECTIONS_IDLE` |                                 | `5`     |
| `DB_HOST`                  | (postgres) Postgresql Hostname  |         |
| `DB_NAME`                  | (postgres)  Postgresql Name     |         |
| `DB_PASS`                  | (postgres)  Postgresql Password |         |
| `DB_PORT`                  | (postgres)  Postgresql Port     | `5432`  |
| `DB_USER`                  | (postgres)  Postgresql User     |         |

#### Access Tokens and Appservices

| Variable                                   | Value | Default |
| ------------------------------------------ | ----- | ------- |
| `ACCESSTOKENS_MAX_CACHE_TIME`              |       | `0`     |
| `ACCESSTOKENS_USE_LOCAL_APPSERVICE_CONFIG` |       | `false` |

#### Repository Options

| Variable                    | Value | Default                      |
| --------------------------- | ----- | ---------------------------- |
| `REPOSITORY_ADMINS`         |       | `@your_username:example.org` |
| `ENABLE_SHARED_SECRET_AUTH` |       | `false`                      |
| `SHARED_SECRET_TOKEN`       |       |                              |

#### Networking Options

| Variable                        | Value | Default   |
| ------------------------------- | ----- | --------- |
| `LISTEN_IP`                     |       | `0.0.0.0` |
| `LISTEN_PORT`                   |       | `8000`    |
| `TRUST_ANY_FORWARDED_ADDRESSES` |       | `TRUE`    |
| `USE_FORWARDED_HOST_HEADER`     |       | `TRUE`    |

#### Homeserver Options

| Variable                      | Value                           | Default  |
| ----------------------------- | ------------------------------- | -------- |
| `DEFAULT_HOMESERVER_BACKOFF`  |                                 | `10`     |
| `DEFAULT_HOMESERVER_API_TYPE` |                                 | `matrix` |
| `HOMESERVER_TIMEOUT`          |                                 | `30`     |
| `HOMESERVER_NAME`             | `example.com`                   |          |
| `HOMESERVER_BASE_URL`         | `https://synapse.tiredofit.ca/` |          |


#### Federation Options

| Variable                     | Value | Default       |
| ---------------------------- | ----- | ------------- |
| `FEDERATION_BACKOFF_FAILURE` |       | `20`          |
| `FEDERATION_IGNORED_HOSTS`   |       | `example.org` |
| `FEDERATION_TIMEOUT`         |       | `120`         |


#### Download and Upload Limits
| Variable                              | Value | Default     |
| ------------------------------------- | ----- | ----------- |
| `UPLOADS_MAX_BYTES`                   |       | `104857600` |
| `UPLOADS_MIN_BYTES`                   |       | `1000`      |
| `DOWNLOADS_MAX_BYTES`                 |       | `104857600` |
| `DOWNLOADS_WORKERS`                   |       | `10`        |
| `DOWNLOADS_FAILURE_CACHE_MINUTES`     |       | `5`         |
| `DOWNLOADS_EXPIRE_DAYS`               |       | `0`         |
| `DOWNLOADS_DEFAULT_RANGE_CHUNK_BYTES` |       | `10485760`  |


#### Metrics Options

| Variable              | Value | Default   |
| --------------------- | ----- | --------- |
| `ENABLE_METRICS`      |       | `false`   |
| `METRICS_LISTEN_IP`   |       | `0.0.0.0` |
| `METRICS_LISTEN_PORT` |       | `9000`    |

#### Datastore Options

| Variable                | Value | Default                     |
| ----------------------- | ----- | --------------------------- |
| `MEDIA_THUMBNAILS_TYPE` |       | `FILE`                      |
| `MEDIA_THUMBNAILS_PATH` |       | `${MEDIA_PATH}/thumbnails/` |
| `MEDIA_REMOTE_TYPE`     |       | `FILE`                      |
| `MEDIA_REMOTE_PATH`     |       | `${MEDIA_PATH}/remote/`     |
| `MEDIA_LOCAL_TYPE`      |       | `FILE`                      |
| `MEDIA_LOCAL_PATH`      |       | `${MEDIA_PATH}/local/`      |
| `MEDIA_ARCHIVES_TYPE`   |       | `FILE`                      |
| `MEDIA_ARCHIVES_PATH`   |       | `${MEDIA_PATH}/archives/`   |

#### URL Previews Options

| Variable                            | Value | Default                                                                                                       |
| ----------------------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| `ENABLE_URL_PREVIEWS`               |       | `true`                                                                                                        |
| `URL_PREVIEWS_MAX_PAGESIZE_BYTES`   |       | `10485760`                                                                                                    |
| `URL_PREVIEWS_PREVIEW_UNSAFE`       |       | `false`                                                                                                       |
| `URL_PREVIEWS_MAX_WORDS`            |       | `50`                                                                                                          |
| `URL_PREVIEWS_MAX_LENGTH`           |       | `200`                                                                                                         |
| `URL_PREVIEWS_MAX_TITLE_WORDS`      |       | `30`                                                                                                          |
| `URL_PREVIEWS_MAX_TITLE_CHARACTERS` |       | `50`                                                                                                          |
| `URL_PREVIEWS_TIMEOUT`              |       | `10`                                                                                                          |
| `URL_PREVIEWS_EXPIRE_DAYS`          |       | `0`                                                                                                           |
| `URL_PREVIEWS_DEFAULT_LANGUAGE`     |       | `en-US,en`                                                                                                    |
| `URL_PREVIEWS_USER_AGENT`           |       | `matrix-media-repo`                                                                                           |
| `URL_PREVIEWS_OEMBED`               |       | `FALSE`                                                                                                       |
| `URL_PREVIEWS_ALLOWED_NETWORKS`     |       | `0.0.0.0/0`                                                                                                   |
| `URL_PREVIEWS_DISALLOWED_NETWORKS`  |       | `127.0.0.1/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.64.0.0/10,169.254.0.0/16,::1/128,fe80::/64,fc00::/7` |
| `URL_PREVIEWS_FILE_TYPES`           |       | `image/*`                                                                                                     |
| `URL_PREVIEWS_WORKERS`              |       | `10`                                                                                                          |

#### Quarantine Options
| Variable                        | Value | Default |
| ------------------------------- | ----- | ------- |
| `QUARANTINE_REPLACE_THUMBNAILS` |       | `TRUE`  |
| `QUARANTINE_REPLACE_DOWNLOADS`  |       | `TRUE`  |
| `QUARANTINE_LOCAL_ADMINS`       |       | `TRUE`  |
| `ENABLE_IDENTICONS`             |       | `TRUE`  |


#### Thumbnail Options
| Variable             | Value | Default                                    |
| -------------------- | ----- | ------------------------------------------ |
| `THUMBNAIL_TYPES`    |       | `image/jpeg,image/jpg,image/png,image/gif` |
| `THUMBNAIL01_HEIGHT` |       | `32`                                       |
| `THUMBNAIL01_WIDTH`  |       | `32`                                       |
| `THUMBNAIL02_HEIGHT` |       | `96`                                       |
| `THUMBNAIL02_WIDTH`  |       | `96`                                       |
| `THUMBNAIL03_HEIGHT` |       | `320`                                      |
| `THUMBNAIL03_WIDTH`  |       | `240`                                      |
| `THUMBNAIL04_HEIGHT` |       | `640`                                      |
| `THUMBNAIL04_WIDTH`  |       | `480`                                      |
| `THUMBNAIL05_HEIGHT` |       | `800`                                      |
| `THUMBNAIL05_WIDTH`  |       | `600`                                      |

#### Plugin Options
| Variable         | Value | Default |
| ---------------- | ----- | ------- |
| `ENABLE_PLUGINS` |       | `FALSE` |

#### Blurhash Options
| Variable                | Value | Default |
| ----------------------- | ----- | ------- |
| `ENABLE_BLURHASH`       |       | `FALSE` |
| `BLURHASH_MAX_WIDTH`    |       | `1024`  |
| `BLURHASH_MAX_HEIGHT`   |       | `1024`  |
| `BLURHASH_THUMB_WIDTH`  |       | `64`    |
| `BLURHASH_THUMB_HEIGHT` |       | `64`    |
| `BLURHASH_X_COMPONENTS` |       | `4`     |
| `BLURHASH_Y_COMPONENTS` |       | `3`     |
| `BLURHASH_PUNCH`        |       | `1`     |

#### Rate Limiting
| Variable                        | Value | Default |
| ------------------------------- | ----- | ------- |
| `ENABLE_RATELIMIT`              |       | `TRUE`  |
| `RATELIMIT_REQUESTS_PER_SECOND` |       | `1`     |
| `RATELIMIT_BURST`               |       | `1`     |

#### Redis Options
| Variable          | Value | Default |
| ----------------- | ----- | ------- |
| `ENABLE_REDIS`    |       | `FALSE` |
| `REDIS_DB_NUMBER` |       | `0`     |

#### Sentry Options
| Variable        | Value | Default                                       |
| --------------- | ----- | --------------------------------------------- |
| `ENABLE_SENTRY` |       | `FALSE`                                       |
| `SENTRY_DSN`    |       | `https://examplePublicKey@ingest.sentry.io/0` |
| `SENTRY_DEBUG`  |       | `FALSE`                                       |


### Networking

| Port   | Protocol | Description       |
| ------ | -------- | ----------------- |
| `8000` | `tcp`    | Matrix Media Repo |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://github.com/turt2live/matrix-media-repo>
