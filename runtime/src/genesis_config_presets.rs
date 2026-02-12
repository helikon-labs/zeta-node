use crate::{
    AccountId, Balance, BalancesConfig, CollatorSelectionConfig, ParachainInfoConfig,
    PolkadotXcmConfig, RuntimeGenesisConfig, SessionConfig, SessionKeys, SudoConfig,
    UNIT as BALANCE_UNIT,
};

use alloc::{vec, vec::Vec};

use polkadot_sdk::{staging_xcm as xcm, *};

use cumulus_primitives_core::ParaId;
use frame_support::build_struct_json_patch;
use parachains_common::AuraId;
use serde_json::Value;
use sp_genesis_builder::PresetId;
use sp_keyring::Sr25519Keyring;

/// The default XCM version to set in genesis config.
const SAFE_XCM_VERSION: u32 = xcm::prelude::XCM_VERSION;
/// Parachain id used for genesis config presets of parachain template.
#[docify::export_content]
pub const PARACHAIN_ID: u32 = 5123;

/// Generate the session keys from individual elements.
/// The input must be a tuple of individual keys (a single arg for now since we have just one key).
pub fn template_session_keys(keys: AuraId) -> SessionKeys {
    SessionKeys { aura: keys }
}

fn get_genesis(
    parachain_id: ParaId,
    root: AccountId,
    balances: Vec<(AccountId, u128)>,
    authority_candidacy_bond: Balance,
    authorities: Vec<(AccountId, AuraId)>,
) -> Value {
    build_struct_json_patch!(RuntimeGenesisConfig {
        balances: BalancesConfig { balances },
        parachain_info: ParachainInfoConfig { parachain_id },
        collator_selection: CollatorSelectionConfig {
            invulnerables: authorities
                .iter()
                .cloned()
                .map(|(acc, _)| acc)
                .collect::<Vec<_>>(),
            candidacy_bond: authority_candidacy_bond,
        },
        session: SessionConfig {
            keys: authorities
                .into_iter()
                .map(|(acc, aura)| {
                    (
                        acc.clone(),                 // account id
                        acc,                         // validator id
                        template_session_keys(aura), // session keys
                    )
                })
                .collect::<Vec<_>>(),
        },
        polkadot_xcm: PolkadotXcmConfig {
            safe_xcm_version: Some(SAFE_XCM_VERSION)
        },
        sudo: SudoConfig { key: Some(root) },
    })
}

fn get_devnet_genesis() -> Value {
    let root = Sr25519Keyring::Alice.to_account_id();
    let balances = Sr25519Keyring::well_known()
        .map(|k| (k.to_account_id(), 1u128 << 60))
        .collect::<Vec<_>>();
    let authority_candidacy_bond = 10_000 * BALANCE_UNIT;
    let authorities = vec![
        (
            Sr25519Keyring::Alice.to_account_id(),
            Sr25519Keyring::Alice.public().into(),
        ),
        (
            Sr25519Keyring::Bob.to_account_id(),
            Sr25519Keyring::Bob.public().into(),
        ),
    ];
    get_genesis(
        PARACHAIN_ID.into(),
        root,
        balances,
        authority_candidacy_bond,
        authorities,
    )
}

fn get_testnet_genesis() -> Value {
    let root = Sr25519Keyring::Alice.to_account_id();
    let balances = Sr25519Keyring::well_known()
        .map(|k| (k.to_account_id(), 1u128 << 60))
        .collect::<Vec<_>>();
    let authority_candidacy_bond = 10_000 * BALANCE_UNIT;
    let authorities = vec![
        (
            Sr25519Keyring::Alice.to_account_id(),
            Sr25519Keyring::Alice.public().into(),
        ),
        (
            Sr25519Keyring::Bob.to_account_id(),
            Sr25519Keyring::Bob.public().into(),
        ),
    ];
    get_genesis(
        PARACHAIN_ID.into(),
        root,
        balances,
        authority_candidacy_bond,
        authorities,
    )
}

/// Provides the JSON representation of predefined genesis config for given `id`.
pub fn get_preset(id: &PresetId) -> Option<vec::Vec<u8>> {
    let patch = match id.as_ref() {
        super::DEVNET_PRESET
        | "dev"
        | ""
        | sp_genesis_builder::DEV_RUNTIME_PRESET
        | sp_genesis_builder::LOCAL_TESTNET_RUNTIME_PRESET => get_devnet_genesis(),
        super::TESTNET_PRESET | "testnet" => get_testnet_genesis(),
        _ => return None,
    };
    Some(
        serde_json::to_string(&patch)
            .expect("serialization to json is expected to work. qed.")
            .into_bytes(),
    )
}

/// List of supported presets.
pub fn preset_names() -> Vec<PresetId> {
    vec![
        PresetId::from(sp_genesis_builder::DEV_RUNTIME_PRESET),
        PresetId::from(super::DEVNET_PRESET),
        PresetId::from(sp_genesis_builder::LOCAL_TESTNET_RUNTIME_PRESET),
        PresetId::from(super::TESTNET_PRESET),
    ]
}
