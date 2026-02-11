#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p ./_chainspec

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --profile production -p zeta-node
# devnet
./target/release/zeta-node export-chain-spec \
    --chain=devnet \
    --output ./_chainspec/zeta_devnet_plain.json
# devnet raw
./target/release/zeta-node export-chain-spec \
    --raw \
    --chain=devnet \
    --output ./_chainspec/zeta_devnet_raw.json
# testnet
./target/release/zeta-node export-chain-spec \
    --chain=testnet \
    --output ./_chainspec/zeta_testnet_plain.json
# testnet raw
./target/release/zeta-node export-chain-spec \
    --raw \
    --chain=testnet \
    --output ./_chainspec/zeta_testnet_raw.json