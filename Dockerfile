# Builder stage
FROM rust:1.76 as builder

# Install clang and other dependencies required for compiling librocksdb-sys
RUN apt-get update && apt-get install -y \
    clang \
    libclang-dev \
    libssl-dev \
    pkg-config \
    build-essential \
    git \
    curl

RUN git clone https://github.com/AleoHQ/snarkOS.git --depth 1 /snarkOS

WORKDIR /snarkOS

RUN cargo build --release && \
    cargo install --path .

# Final stage
FROM ubuntu:22.04

# Install runtime dependencies including dnsutils for the 'dig' command
RUN apt-get update && apt-get install -y \
    libcurl4 \
    dnsutils

# Copy the built binary from the builder stage
COPY --from=builder /usr/local/cargo/bin/snarkos /usr/local/bin/snarkos

# Copy the startup script into the image
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose necessary ports
EXPOSE 3030 4130-4230 5000

# Set the entry point to use the startup script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
