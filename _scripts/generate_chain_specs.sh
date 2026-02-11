#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p chain-spec

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --release --workspace
# devnet
./target/release/zeta-node export-chain-spec --chain=devnet --output ./chain-spec/zeta_devnet_plain.json
./target/release/zeta-node export-chain-spec --raw --chain=devnet --output ./chain-spec/zeta_devnet_raw.json
# testnet
./target/release/zeta-node export-chain-spec --chain=testnet --output ./chain-spec/zeta_testnet_plain.json
./target/release/zeta-node export-chain-spec --raw --chain=testnet --output ./chain-spec/zeta_testnet_raw.json