# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.1.2
FROM debian:trixie-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

COPY socials/ .

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y libyaml-dev libsqlite3-0 libvips curl build-essential pkg-config ruby ruby-dev ruby-bundler
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN bundle install
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
RUN bundle exec bootsnap precompile --gemfile

RUN bundle exec bootsnap precompile app/ lib/

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["/rails//bin/rails", "server"]
