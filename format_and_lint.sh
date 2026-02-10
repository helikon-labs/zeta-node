#!/usr/bin/env bash
set -euo pipefail

cargo +nightly fmt
SKIP_PALLET_REVIVE_FIXTURES=1 SKIP_WASM_BUILD=1 cargo clippy --all-targets --all-features --locked --workspace