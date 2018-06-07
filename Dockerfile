From ubuntu:17.10

MAINTAINER Daniel Wheeler <daniel.wheeler2@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get -y update
RUN apt-get install -y apt-utils && apt-get clean
RUN apt-get install -y sudo && apt-get clean
RUN apt-get install -y bzip2 && apt-get clean
RUN apt-get install -y curl && apt-get clean
RUN apt-get -y update

RUN useradd -m -s /bin/bash main
RUN echo "main:main" | chpasswd
RUN adduser main sudo

EXPOSE 8888

USER main

ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

USER root

RUN chown -R main:main /home/main
RUN echo "main ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /etc/nix
RUN echo "build-users-group =" > /etc/nix/nix.conf

USER main

## Install Nix

RUN curl https://nixos.org/nix/install > ./install.sh
RUN bash ./install.sh
RUN cp ~/.nix-profile/etc/profile.d/nix.sh ~/nix.sh
RUN chmod +wx ~/nix.sh
RUN /bin/bash -c "echo -e 'unset PATH\n$(cat ~/nix.sh)' > ~/nix.sh"
RUN echo "export PATH=\$PATH:/nix/var/nix/profiles/default/bin:/bin:/usr/bin" >> ~/nix.sh
RUN echo "export NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/\$USER " >> ~/nix.sh
RUN echo "export MANPATH=/nix/var/nix/profiles/default/share/man:\$HOME/.nix-profile/share/man:\$MANPATH" >> ~/nix.sh
COPY shell.nix ./
COPY _nix/ ./_nix/
RUN /bin/bash -c " \
    source ~/nix.sh; \
    nix-env -i git; \
    nix-shell; \
    git clone https://github.com/usnistgov/pfhub;"

RUN echo "source ~/nix.sh" >> ~/.bashrc
EXPOSE 4000
