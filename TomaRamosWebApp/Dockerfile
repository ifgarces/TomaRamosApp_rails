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

# For the IMGkit ruby gem
# RUN add-apt-repository -y ppa:linuxuprising/libpng12 \
#     && apt-get update --quiet && apt-get install -y \
#         libpng12-0

# RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
#     && dpkg -i /tmp/libpng12.deb \
#     && rm /tmp/libpng12.deb
# RUN gem install imgkit wkhtmltoimage-binary
# RUN wget -O /tmp/wkhtml.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb \
#     && apt-get install -y /tmp/wkhtml.deb \
# RUN ARCHITECTURE=amd64 imgkit --install-wkhtmltoimage

EXPOSE ${WEB_SERVER_PORT}

ENTRYPOINT [ "./docker-entrypoint.sh" ]
