FROM ruby:2.3.0
RUN apt-get update && apt-get install -y build-essential libpq-dev

ADD . /app
WORKDIR /app

RUN bundle install
