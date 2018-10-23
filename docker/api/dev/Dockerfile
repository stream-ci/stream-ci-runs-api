FROM ruby:2.5.1-slim-stretch

# Set build args for group and user
ARG SCI_RUNS_API_USER_ID
ARG SCI_RUNS_API_USER_NAME
ARG SCI_RUNS_API_GROUP_ID
ARG SCI_RUNS_API_GROUP_NAME

# Install sudo
RUN apt-get update && apt-get install -y sudo

# Add user to sudoers
RUN echo "$SCI_RUNS_API_USER_NAME ALL=(root) NOPASSWD:ALL" \
    > /etc/sudoers.d/$SCI_RUNS_API_USER_NAME && \
    chmod 0440 /etc/sudoers.d/$SCI_RUNS_API_USER_NAME

# Create group
RUN groupadd -g $SCI_RUNS_API_GROUP_ID $SCI_RUNS_API_GROUP_NAME

# Create user
RUN useradd -u $SCI_RUNS_API_USER_ID \
            -g $SCI_RUNS_API_GROUP_ID \
            -G root \
            -m \
            -s /bin/bash \
            $SCI_RUNS_API_USER_NAME

# Set user
USER ${SCI_RUNS_API_USER_NAME}

# Set current directory
WORKDIR /app

# Install build dependencies
RUN sudo apt-get install -y \
    build-essential \
    nodejs

# Add Gemfile
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock

# Start app
CMD ./bin/start
