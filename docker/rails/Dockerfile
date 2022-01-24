ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}
RUN apt-get update -qq && apt-get install -y build-essential
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY docker/rails/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]