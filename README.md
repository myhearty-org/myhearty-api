# MyHearty API

MyHearty API powers [MyHearty website](https://www.myhearty.my) and [MyHearty dashboard](https://dashboard.myhearty.my). This repository contains the backend implementation of MyHearty API in Ruby on Rails and other backend services. The Rails application is running in API mode and serves JSON resources to the frontend API clients.

## Architecture Overview

You can find the architecture overview in the illustration below, which will give you a good starting point in how the backend services interact with other services.

<div align="center">
  <img src="docs/images/high-level-architecture.svg" alt="MyHearty High-Level Architecture" width="75%" height="75%">
</div>

## Development

To get the backend services up and running, read the following subsections.

### Requirements

If you have [Docker](https://docs.docker.com/engine/install) and [Docker Compose](https://docs.docker.com/compose/install) installed, you can set up and run the services easily via the provided [`docker-compose.yml`](./docker-compose.yml) file.

If you **do not** want to use Docker Compose, you need to install the following requirements to be able to run the services locally:

- Ruby 3.0+
- PostgreSQL 14.0+
- Redis 6.0+
- Typesense 0.22+
- NGINX 1.21+

The rest of the documentation is only applicable to those that have installed Docker Compose.

### Getting Started

1. Clone the repo.
   ```sh
   git clone https://github.com/myhearty-org/myhearty-api.git
   ```
2. Create a `.env` file in the root directory by copying the environment variables from the [`.env.example`](./.env.example) file. You can change versions of the services there. For more information on populating environment variables, refer to the [services section](#services).
3. To start the services using Docker Compose, you can either:
   - Run the required services only by specifying the services' names:
     ```sh
     docker-compose up -d [service1, service2, ...]
     ```
   - Run all services:
     ```sh
     docker-compose up -d
     ```
4. To start an interactive shell inside any service, run:
   ```sh
   docker-compose exec [service-name] sh
   ```
   This is useful when you want to interact with the service's internal states or run some console commands.
5. To stop the services, you can either:
   - Stop certain services only by specifying the services' names:
     ```sh
     docker-compose stop [service1, service2, ...]
     ```
   - Stop all services:
     ```sh
     docker-compose stop
     ```
6. To remove the containers together with saved states and start everything from scratch again, run:
   ```sh
   docker-compose down -v
   ```
   > **Warning** <br />
   > This is a destructive action that will delete all data stored in the PostgreSQL database and Typesense search engine.

> **Note** <br />
> If you want to enable any of the available integrations, you may want to obtain additional credentials and populate secrets for the corresponding integration. Refer to the [integrations section](#integrations) for more details.

## Services

The [`docker-compose.yml`](./docker-compose.yml) file contains the following services:

| Service     | Description                                                                                                                          | Endpoint                |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------- |
| `api`       | The Rails API server                                                                                                                 | `http://localhost:3000` |
| `db`        | The PostgreSQL database                                                                                                              | `http://localhost:5432` |
| `typesense` | The Typesense search engine that powers instant search and geosearch in the frontend                                                 | `http://localhost:8108` |
| `sidekiq`   | The background job scheduler for Ruby                                                                                                | NO ENDPOINT             |
| `redis`     | Provides data storage for Sidekiq                                                                                                    | `http://localhost:6379` |
| `nginx`     | Acts as a reverse proxy server that directs the client requests to either the Rails API server or Typesense based on the request URL | NO ENDPOINT             |

Refer to the services' official image repositories for the configuration of environment variables in the [`docker-compose.yml`](./docker-compose.yml) file.

### Generating Credentials

Some services require credentials like a password or a bootstrap API key. You can use Ruby's built-in `SecureRandom` library to generate a secure random string:

1. Open a shell in the `api` container.

```sh
docker-compose exec api sh
```

2. Generate a random string:

```sh
rails c
> SecureRandom.alphanumeric(32) # your random string length
```

### Rails API Server

The Rails application contains the code required to run the MyHearty API server. If you make changes to the [`Gemfile`](./Gemfile) or the [`docker-compose.yml`](./docker-compose.yml) file to try out some different configurations, you need to rebuild. If the changes involved [`Gemfile`](./Gemfile) like adding/removing gems, you need to:
- Sync changes in the `Gemfile.lock` to the host:
  ```sh
  docker compose run api bundle install
  ```
- Rebuild the images:
  ```sh
  docker compose up --build
  ```

Other changes require you to run the second command only.

### PostgreSQL

1. Populate the following PostgreSQL's related environment variables in the `.env` file before starting the database:
   ```sh
   POSTGRES_USER= # your DB username
   POSTGRES_PASSWORD= # your DB password
   POSTGRES_HOST=postgres # your DB host
   ```
   - If the variables are not set, the service will use the defaults provided by the PostgreSQL image.
   - `POSTGRES_HOST` is set to `postgres` to allow other services to communicate with the database service using network alias. See [`docker-compose.yml#L42`](./docker-compose.yml#L42) for more detail.
2. To create the database, run the following commands:
   - Open a shell in the `api` container.
     ```sh
     docker-compose exec api sh
     ```
   - Create the database and load the schema:
     ```sh
     rake db:create
     rake db:schema:load
     ```
3. To seed data, run:
   ```sh
   rake db:seed SEEDS_MULTIPLIER=2
   ```
   - The environment variable `SEEDS_MULTIPLIER` defaults to 1 and controls the amount of data generated by the seeder.
   - Note that, during seeding, Typesense schema will be deleted and later re-created. Certain resources from the database will be indexed into Typesense to enable instant search. See [`01_typesense.rb`](./db/seeds/01_typesense.rb) for more detail.
   - The populated data include user credentials and fake image URLs. See [`02_resources.rb`](./db/seeds/02_resources.rb) to understand what types of data are being populated.
4. To remove data, run:
   ```sh
   rake db:truncate
   ```
   - This command is useful when you want to re-seed the database.
   - This is a custom task defined in [`db.rake`](./lib/tasks/db.rake).

PostgreSQL can be further configured in [`database.yml`](./config/database.yml).

### Typesense

[Typesense](https://typesense.org) is an open-source, typo-tolerant search engine that is optimized for instant search. It is an easier-to-use alternative for commercial search API like Algolia, which has high pricing, or open-source search engine like Elasticsearch, which can be complicated to tune.

1. Generate an API key before starting Typesense.
2. Assign the API key to the `TYPESENSE_API_KEY` variable in the `.env` file.
3. To start Typesense, run:
   ```sh
   docker-compose up -d typesense
   ```

### Sidekiq and Redis

Sidekiq is dependent on Redis as the data storage provider. To enable background processing:

1. Generate a password before starting Redis.
2. Assign the password to the `REDIS_PASSWORD` variable in the `.env` file.
3. To start Sidekiq, run:
   ```sh
   docker-compose up -d redis sidekiq
   ```

Sidekiq can be further configured in [`sidekiq.rb`](./config/initializers/sidekiq.rb) and [`sidekiq.yml`](./config/sidekiq.yml).

### NGINX

NGINX acts as a reverse proxy server that directs the client requests to either the Rails API server or Typesense based on the request URL. It can be configured in [`nginx.conf`](./docker/nginx/nginx.conf).

## Integrations

### Credentials

### Stripe

### S3

### Geoapify

### Sendgrid

### Frontend

You can find the source code, demo and documentation for the frontend in the [myhearty](https://github.com/myhearty-org/myhearty) repository.

## Documentation

The full documentation for the MyHearty project can be found in the [myhearty-documentation](https://github.com/myhearty-org/myhearty-documentation) repository. The documentation repository contains technical documents and architecture information related to the implementation of this project.

## Contributing

If you want to contribute, please fork the repo and create a pull request by following the steps below:

1. Fork the repo.
2. Create your feature branch (`git checkout -b your-feature-branch`).
3. Commit your changes and push to the branch (`git push origin your-feature-branch`).
4. Open a pull request.

Your changes will be reviewed and merged if appropriate.

## References

- [Rails Guides: Using Rails for API-only Applications](https://guides.rubyonrails.org/api_app.html)
- [Docker Docs: Quickstart: Compose and Rails](https://docs.docker.com/samples/rails)
- [GitHub: Dockerize Rails 7 with ActionCable, Webpacker, Stimulus, Elasticsearch, Sidekiq](https://github.com/ledermann/docker-rails)
- [Devise GitHub Wiki: API Mode Compatibility Guide](https://github.com/heartcombo/devise/wiki/API-Mode-Compatibility-Guide)
- [GitHub: Accept payments with Stripe Checkout (Ruby Server Implementation)](https://github.com/stripe-samples/checkout-one-time-payments/tree/master/server/ruby)
- [Shrine GitHub Wiki: Adding Direct S3 Uploads](https://github.com/shrinerb/shrine/wiki/Adding-Direct-S3-Uploads)
