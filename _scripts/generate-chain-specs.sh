#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..
mkdir -p ./_chainspec

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --profile production -p zeta-node
# devnet
./target/production/zeta-node export-chain-spec \
    --chain=zeta_devnet \
    --output ./_chainspec/zeta-devnet-plain.json
# devnet raw
./target/production/zeta-node export-chain-spec \
    --raw \
    --chain=zeta_devnet \
    --output ./_chainspec/zeta-devnet-raw.json
# testnet
./target/production/zeta-node export-chain-spec \
    --chain=zeta_testnet \
    --output ./_chainspec/zeta-testnet-plain.json
# testnet raw
./target/production/zeta-node export-chain-spec \
    --raw \
    --chain=zeta_testnet \
    --output ./_chainspec/zeta-testnet-raw.json