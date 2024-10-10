FROM ubuntu:jammy

ARG TARGETARCH

RUN apt-get update \
    &&  apt-get install -y ca-certificates curl libcurl4 openssl wait-for-it tini \
    &&  rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates

COPY target/$TARGETARCH/release/cached-eth-rpc /app/cached-eth-rpc
RUN chmod +x /app/cached-eth-rpc

ENV ENDPOINTS="eth-chain=https://rpc.ankr.com/eth,bsc-chain=https://rpc.ankr.com/bsc"
ENV RUST_LOG="debug"
ENV RUST_LOG_FORMAT="full"
HEALTHCHECK --interval=1s --timeout=1s --retries=1 CMD curl http://localhost:8124
EXPOSE 8124
ENTRYPOINT ["tini", "--", "/app/cached-eth-rpc" ]
