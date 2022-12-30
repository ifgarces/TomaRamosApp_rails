ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

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

# Copying encription key for sessions
COPY tmp/development_secret.txt ./tmp/development_secret.txt

# Just for debugging
COPY Makefile .

# Installing application packages
RUN mkdir storage \
    && bundle install \
	&& yarn install --check-files

# For some reason, I cannot place an embedded ENV variable value for the host at `database.yml`, so
# for virtualized runtime, the database URL is override as follows
RUN rm -f ./config/database.yml
ENV DATABASE_URL="postgresql://tomaramosuandes:tomaramosuandes@tomaramos-postgres:${POSTGRES_PORT}/tomaramosuandes_development"

# Creating SSL certs
ARG SSL_CERT_FILE=/tmp/certs/tomaramos.app.crt
ARG SSL_KEY_FILE=/tmp/certs/tomaramos.app.key
RUN mkdir -p /tmp/certs/
RUN echo "\n\
[ req ]\n\
prompt                 = no\n\
days                   = 365\n\
distinguished_name     = req_distinguished_name\n\
req_extensions         = v3_req\n\
\n\
[ req_distinguished_name ]\n\
countryName            = CL\n\
stateOrProvinceName    = Metropolitana\n\
localityName           = Santiago\n\
organizationName       = localhost\n\
organizationalUnitName = R&D\n\
commonName             = localhost\n\
emailAddress           = hostmaster@tomaramos.app\n\
\n\
[ v3_req ]\n\
basicConstraints       = CA:false\n\
extendedKeyUsage       = serverAuth\n\
subjectAltName         = @sans\n\
\n\
[ sans ]\n\
DNS.0 = localhost\n\
DNS.1 = localhost\n\
" >> /tmp/csr-local.conf \
    && openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -utf8 \
        -keyout ${SSL_KEY_FILE} \
        -out ${SSL_CERT_FILE} \
        -config /tmp/csr-local.conf
ENV SSL_CERT_FILE=${SSL_CERT_FILE}
ENV SSL_KEY_FILE=${SSL_KEY_FILE}

COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

ARG RAILS_APP_PORT
EXPOSE ${RAILS_APP_PORT}

ARG 443
EXPOSE 443

ENTRYPOINT [ "./docker-entrypoint.sh" ]
