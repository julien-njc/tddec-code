# Build environment for the TDD-EC book code: gcc 16 + a prebuilt CppUTest v4.0.
FROM gcc:16

ARG CPPUTEST_VERSION=v4.0

ENV CPPUTEST_HOME=/opt/cpputest

RUN apt-get update \
 && apt-get install -y --no-install-recommends gdb \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch $CPPUTEST_VERSION https://github.com/cpputest/cpputest.git $CPPUTEST_HOME \
 && cd $CPPUTEST_HOME \
 && autoreconf . -i \
 && ./configure \
 && make tdd

WORKDIR /usr/src/tddec-code
CMD ["make"]
