#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p ./_deployment

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --profile production -p zeta-node
./target/production/zeta-node export-genesis-wasm \
    --chain=zeta_testnet \
    ./_deployment/zeta-testnet.wasm
./target/production/zeta-node export-genesis-wasm \
    --raw \
    --chain=zeta_testnet \
    ./_deployment/zeta-testnet-raw.wasm
./target/production/zeta-node export-genesis-head \
    --chain=zeta_testnet \
    ./_deployment/zeta-testnet.head
./target/production/zeta-node export-genesis-head \
    --raw \
    --chain=zeta_testnet \
    ./_deployment/zeta-testnet-raw.head
