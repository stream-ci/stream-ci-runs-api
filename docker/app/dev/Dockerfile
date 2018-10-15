FROM ruby:2.5.1-slim-stretch

# Set build args for group and user
ARG SCR_APP_USER_ID
ARG SCR_APP_USER_NAME
ARG SCR_APP_GROUP_ID
ARG SCR_APP_GROUP_NAME

# Install sudo
RUN apt-get update && apt-get install -y sudo

# Add user to sudoers
RUN echo "$SCR_APP_USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$SCR_APP_USER_NAME && \
    chmod 0440 /etc/sudoers.d/$SCR_APP_USER_NAME

# Create group
RUN groupadd -g $SCR_APP_GROUP_ID $SCR_APP_GROUP_NAME

# Create user
RUN useradd -u $SCR_APP_USER_ID \
            -g $SCR_APP_GROUP_ID \
            -G root \
            -m \
            -s /bin/bash \
            $SCR_APP_USER_NAME

# Set user
USER ${SCR_APP_USER_NAME}

# Set current directory
WORKDIR /app

# Install build dependencies
RUN sudo apt-get install -y \
    build-essential \
    # postgresql \
    # postgresql-contrib \
    # libpq-dev \
    nodejs

# Add Gemfile
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock

# Start app
CMD ./bin/start

# How to use
#
# $ docker run --rm --name um-web-app-dev -v $(pwd):/app jconant/um-web-app-dev:latest
