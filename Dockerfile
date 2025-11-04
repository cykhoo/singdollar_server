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

ARG GITHUB_USER=cykhoo

# Install gems with auth for both GitHub git sources and GitHub Packages
RUN --mount=type=secret,id=github_pat \
    set -eux; \
    TOKEN="$(cat /run/secrets/github_pat)"; \
    # 1) allow bundler to fetch private git repos via https://github.com
    git config --global url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"; \
    # 2) allow bundler to fetch gems from rubygems.pkg.github.com/<owner>
    bundle config set --global rubygems.pkg.github.com "${GITHUB_USER}:${TOKEN}"; \
    # optional: keep image smaller and skip non-prod groups
    bundle config set without 'development test'; \
    bundle install --jobs 4 --retry 3; \
    # clean up git rewrite so the token is not left in git config
    git config --global --unset url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf

# App code last
COPY . .

EXPOSE 4000
# add get('/health'){ 'ok' } in the app and use SELENIUM_REMOTE_URL
CMD ["bundle","exec","rackup","-p","4000","-o","0.0.0.0"]
