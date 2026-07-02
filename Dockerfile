FROM rust:1.85-bookworm AS builder

WORKDIR /app

ARG CRATE=api-server

COPY Cargo.toml Cargo.lock ./
COPY crates ./crates

RUN cargo build --release -p ${CRATE}

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG CRATE=api-server
COPY --from=builder /app/target/release/${CRATE} /usr/local/bin/app

ENTRYPOINT ["/usr/local/bin/app"]