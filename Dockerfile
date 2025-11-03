# syntax=docker/dockerfile:1.7
ARG RUBY_VERSION=3.4.1
FROM ruby:${RUBY_VERSION}-slim-bookworm

ENV APP_HOME=/app RACK_ENV=production
WORKDIR ${APP_HOME}

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git openssh-client curl pkg-config libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# GitHub host key
RUN mkdir -p -m 700 /root/.ssh \
 && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Bundle first for cache
COPY Gemfile Gemfile.lock ./

# Private git repos via HTTPS
RUN --mount=type=secret,id=github_pat \
    TOKEN="$(cat /run/secrets/github_pat)" && \
    git config --global url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/" && \
    bundle config set without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    git config --global --unset url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf

# App code last
COPY . .

EXPOSE 4000
# add get('/health'){ 'ok' } in the app and use SELENIUM_REMOTE_URL
CMD ["bundle","exec","rackup","-p","4000","-o","0.0.0.0"]
