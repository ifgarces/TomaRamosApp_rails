ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /home/tomaramos/webapp

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

# Copying encription key for sessions
COPY tmp/development_secret.txt ./tmp/development_secret.txt

# Just for debugging
COPY Makefile .

# Installing application packages
RUN mkdir storage \
    && bundle install \
	&& yarn install --check-files

# Replacing host to postgres container in database connection file (for some reason, could not do
# it with ENV variables)
RUN sed -i "s/localhost/tomaramos-postgres/g" ./config/database.yml

COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

ARG WEB_SERVER_PORT
EXPOSE ${WEB_SERVER_PORT}

ENTRYPOINT [ "./docker-entrypoint.sh" ]
