use crate::{mock_runtime, Error, Value};
use frame::testing_prelude::*;

#[test]
fn store_value_works() {
    mock_runtime::new_test_ext().execute_with(|| {
        assert_ok!(mock_runtime::Zeta::store_value(
            mock_runtime::RuntimeOrigin::signed(1),
            42u32
        ));
        assert_eq!(
            Value::<mock_runtime::Test>::get().map(|v| v.value),
            Some(42u32)
        );
    });
}

#[test]
fn increment_value_works() {
    mock_runtime::new_test_ext().execute_with(|| {
        assert_ok!(mock_runtime::Zeta::store_value(
            mock_runtime::RuntimeOrigin::signed(1),
            u32::MAX - 1,
        ));
        assert_ok!(mock_runtime::Zeta::increment_value(
            mock_runtime::RuntimeOrigin::signed(1)
        ));
        assert_eq!(
            Value::<mock_runtime::Test>::get().map(|v| v.value),
            Some(u32::MAX)
        );
    });
}

#[test]
fn correct_error_for_increment_none_value() {
    mock_runtime::new_test_ext().execute_with(|| {
        assert_noop!(
            mock_runtime::Zeta::increment_value(mock_runtime::RuntimeOrigin::signed(1)),
            Error::<mock_runtime::Test>::NoneValue,
        );
    });
}

#[test]
fn correct_error_for_increment_overflow() {
    mock_runtime::new_test_ext().execute_with(|| {
        assert_ok!(mock_runtime::Zeta::store_value(
            mock_runtime::RuntimeOrigin::signed(1),
            u32::MAX - 1,
        ));
        assert_ok!(mock_runtime::Zeta::increment_value(
            mock_runtime::RuntimeOrigin::signed(1)
        ));
        assert_noop!(
            mock_runtime::Zeta::increment_value(mock_runtime::RuntimeOrigin::signed(1)),
            Error::<mock_runtime::Test>::StorageOverflow,
        );
    });
}
