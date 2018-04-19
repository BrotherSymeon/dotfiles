FROM ubuntu:latest

# Locales
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Common packages
RUN apt-get update && apt-get install -y \
      build-essential \
      tzdata \
      curl \
      git \
      wget \
      tmux \
      vim \
      zsh \
      ledger \
      mosh \
      mosquitto \
      mosquitto-clients

# Install Node.js LTS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Install oh-my-zsh
RUN chsh -s /usr/bin/zsh
RUN curl -L http://install.ohmyz.sh | sh || true

# Set up timezone
ENV TZ 'Europe/Berlin'
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Set up dotfiles
COPY ./zsh/* /root/
COPY ./vim/ /root/
COPY ./git/* /root/

# Set up volumes
WORKDIR /projects
VOLUME /projects
VOLUME /keys

# Enable colors
ENV TERM=xterm-256color

CMD ["tmux"]
