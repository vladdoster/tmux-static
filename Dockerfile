ARG VERSION=${VERSION:-3.3-rc}

FROM ubuntu:latest as build-stage
ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION}

RUN \
    apt-get update \
 && apt install --yes \
  automake \
  bison \
  build-essential \
  libevent-dev \
  ncurses-dev \
  pkg-config \
  wget
    #  wget -O- https://github.com/tmux/tmux/archive/${VERSION}.tar.gz \

RUN \
    wget -O- https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz \
  | tar -xzvf -

WORKDIR tmux-${VERSION}

RUN \
    ./configure --enable-static \
 && make -j8

FROM scratch as exporter
ARG VERSION

COPY --from=build-stage /tmux-${VERSION}/tmux /
