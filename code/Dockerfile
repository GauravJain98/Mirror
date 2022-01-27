FROM alpine:latest as build

#
# First get all the packages for
# the compile
#
RUN apk update && apk add make \
  file \
  autoconf \
  automake \
  build-base \
  libtool \
  db-c++ \
  db-dev \
  boost-system \
  boost-program_options \
  boost-filesystem \
  boost-dev \
  libressl-dev \
  libevent-dev \
  gnupg

RUN set -ex \
  && for key in \
  01EA5486DE18A882D4C2684590C8019E36C2E964 \
  ; do \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
  gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
  gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV BITCOIN_VERSION=0.21.0
ENV BITCOIN_PREFIX=/opt/bitcoin-${BITCOIN_VERSION}

RUN wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz
RUN gpg --verify SHA256SUMS.asc
RUN grep " bitcoin-${BITCOIN_VERSION}.tar.gz\$" SHA256SUMS.asc | sha256sum -c -
RUN tar -xzf *.tar.gz

WORKDIR /bitcoin-${BITCOIN_VERSION}

#
# Do the actual build
#
RUN (./autogen.sh && \
  ./configure --disable-tests \
  --disable-bench --disable-static  \
  --without-gui --disable-zmq \
  --with-incompatible-bdb \
  CFLAGS='-w' CXXFLAGS='-w' && \
  make -j 4 && \
  strip src/bitcoind && \
  strip src/bitcoin-cli && \
  strip src/bitcoin-tx && \
  make install )


FROM build as final

#
# Copy the binaries from the build to our new container
#
COPY --from=build /usr/local/bin/bitcoind /usr/local/bin
COPY --from=build /usr/local/bin/bitcoin-cli /usr/local/bin

#
# Install all dependencies
#
RUN apk update && apk --no-cache add \
  boost-filesystem \
  boost-system \
  boost-thread \
  libevent \
  libzmq \
  su-exec

#
# Expose the port for the RPC interface
#
EXPOSE 18332/tcp

#
# Start the bitcoin server
#
CMD /usr/local/bin/bitcoind -datadir=/home/bitcoin/.bitcoin
