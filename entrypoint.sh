#!/bin/bash

# Resolve service name to IP
PEERS_IP=$(dig +short snarkos-validator-0 @127.0.0.11)
VALIDATORS_IP=$(dig +short snarkos-validator-0 @127.0.0.11)

# Fallback in case DNS resolution fails
if [ -z "$PEERS_IP" ]; then
    PEERS_IP="snarkos-validator-0"
fi

if [ -z "$VALIDATORS_IP" ]; then
    VALIDATORS_IP="snarkos-validator-0"
fi

# Construct the peer and validator strings
PEERS="${PEERS_IP}:4130"
VALIDATORS="${VALIDATORS_IP}:5000"

# Start snarkos with resolved IPs
exec snarkos start --nodisplay --bft 0.0.0.0:5000 --rest 0.0.0.0:3030 \
     --peers $PEERS --validators $VALIDATORS \
     --verbosity 1 --dev $NODE_ID --dev-num-validators $NUM_INSTANCES \
     --validator --metrics
