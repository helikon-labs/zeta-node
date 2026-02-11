#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p ./_deployment

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --profile production -p zeta-node
./target/production/zeta-node export-genesis-wasm \
    --chain=testnet \
    ./_deployment/zeta_testnet.wasm
./target/production/zeta-node export-genesis-wasm \
    --raw \
    --chain=testnet \
    ./_deployment/zeta_testnet_raw.wasm
./target/production/zeta-node export-genesis-head \
    --chain=testnet \
    ./_deployment/zeta_testnet.head
./target/production/zeta-node export-genesis-head \
    --raw \
    --chain=testnet \
    ./_deployment/zeta_testnet_raw.head
