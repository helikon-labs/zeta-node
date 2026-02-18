#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1
cd ..

taplo format -c .config/taplo.toml
cargo +nightly fmt
SKIP_PALLET_REVIVE_FIXTURES=1 SKIP_WASM_BUILD=1 cargo clippy --all-targets --all-features --locked --workspace