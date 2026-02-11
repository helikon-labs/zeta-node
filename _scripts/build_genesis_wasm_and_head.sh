#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p _wasm

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --release --workspace
#./target/release/zeta-node export-genesis-wasm --chain=testnet ./_deployment/zeta_testnet.wasm
./target/release/zeta-node export-genesis-wasm --raw --chain=testnet ./_deployment/zeta_testnet.wasm
#./target/release/zeta-node export-genesis-head --chain=testnet ./_deployment/zeta_testnet.head
./target/release/zeta-node export-genesis-head --raw --chain=testnet ./_deployment/zeta_testnet.head