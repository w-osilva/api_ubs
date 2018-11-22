# Ruby Image
FROM ruby:2.5

ARG RAILS_ENV

# Get nodejs 8, this image repo comes with 4.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update -qq \
 && apt-get upgrade -y \
 && apt-get install -y apt-utils \
 && apt-get install -y build-essential libpq-dev nodejs netcat vim telnet curl mysql-client apt-transport-https rsync

# Create and Set the working directory
RUN gem install bundler
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install

# Copy application
ADD . /app

# Create database.yml if they don't exist
RUN [ -f config/database.yml ] || /bin/cp -f config/database.yml.sample config/database.yml

# Install Yarn
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
# && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
# && apt-get update -qq \
# && apt-get install -y yarn

# Precompile assets to accelerate execution
#RUN RAILS_ENV=$RAILS_ENV bin/rake assets:precompile

RUN chmod +x /app/bin/run.sh
CMD /app/bin/run.sh
