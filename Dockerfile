FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Install dependencies:
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    sudo \
    wget \
    ffmpeg \
    git \
    make \
    busybox \
    build-essential \
    zip \
    nodejs \
    php \
    php-curl \
    php-mbstring \
    php-mysql \
    php-common \
    php-json \
    npm \
    python3-pip \
 && mkdir -p /home/.config
 
RUN python3 -m pip install --upgrade pip

RUN pip3 install telegram-upload

# Set work dir:
WORKDIR /home

# Copy files:
COPY startbot.sh /home
COPY /Scripts /home
COPY config.sh /home
COPY /config /home/.config

RUN chmod -R +x /home/*

# Run config.sh and clean up APT:
RUN sh /home/config.sh \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the bot:
RUN git clone https://github.com/Nirzak/sh-bot-run.git \
 && cd sh-bot-run \
 && npm install

RUN chmod -R +rwx /home/sh-bot-run

RUN useradd -m nirzak && echo "nirzak:nirzak" | chpasswd && adduser nirzak sudo
USER nirzak

# Run bot script:
CMD bash /home/startbot.sh
