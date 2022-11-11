ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG WEB_SERVER_PORT

WORKDIR /home/tomaramos/webapp
ARG DEBIAN_FRONTEND=noninteractive

# Installing NodJS, Yarn and some debugging utilities
RUN apt-get update --quiet && apt-get install -y \
        build-essential software-properties-common postgresql-client \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | \
        tee /usr/share/keyrings/yarnkey.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | \
        tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update --quiet && apt-get install -y \
        nodejs yarn

# Stylizing PS1, for when opening an interactive shell
RUN echo 'PS1="\[\033[1;33m\]tomaramos-rails-container::\[\033[0m\]${PWD} $ "' >> /root/.bashrc

COPY config.ru .
COPY Gemfile .
COPY package.json .
COPY Rakefile .
COPY app/ app/
COPY bin/ bin/
COPY config/ config/
COPY db/ db/
COPY lib/ lib/
COPY markdown/ markdown/
COPY public/ public/
COPY test/ test/

COPY tmp/development_secret.txt ./tmp/development_secret.txt

# Just for debugging
COPY Makefile .

# Installing application packages
RUN mkdir storage \
    && bundle install \
	&& yarn install --check-files

# As Rails is not smart enough to properly load its own `database.yaml` for database connection
ENV DATABASE_URL="postgresql://tomaramosuandes:tomaramosuandes@tomaramos-postgres:${POSTGRES_PORT}/tomaramosuandes_development"

COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

EXPOSE ${WEB_SERVER_PORT}

ENTRYPOINT [ "./docker-entrypoint.sh" ]
