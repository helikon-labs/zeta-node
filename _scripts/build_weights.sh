#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..

SKIP_PALLET_REVIVE_FIXTURES=1 cargo build --release --workspace --features runtime-benchmarks
./target/release/zeta-node benchmark pallet --chain=zeta_testnet --wasm-execution=compiled --pallet=pallet_zeta --extrinsic=* --steps=50 --repeat=20 --output ./pallets/zeta/src/weights.rs --template=./_scripts/frame_weight_template.hbs