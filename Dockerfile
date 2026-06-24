FROM ubuntu:20.04

ARG TOOLCHAIN_URL=https://developer.arm.com/-/media/files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        make \
        wget \
        bzip2 \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q "${TOOLCHAIN_URL}" -O /tmp/gcc-arm.tar.bz2 && \
    mkdir -p /opt/gcc-arm && \
    tar -xjf /tmp/gcc-arm.tar.bz2 -C /opt/gcc-arm --strip-components=1 && \
    rm /tmp/gcc-arm.tar.bz2

ENV PATH="/opt/gcc-arm/bin:${PATH}"

WORKDIR /lwb
COPY . .

RUN make
