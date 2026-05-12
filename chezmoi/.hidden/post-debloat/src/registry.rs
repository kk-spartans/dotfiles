use windows::Win32::System::Registry::{
    HKEY, HKEY_CURRENT_USER, REG_BINARY, RegCloseKey, RegCreateKeyExW, RegSetValueExW,
};
use windows::core::w;

pub fn apply_post_debloat_registry_tweaks() -> Result<(), String> {
    set_user_preferences_mask()?;
    Ok(())
}

fn set_user_preferences_mask() -> Result<(), String> {
    unsafe {
        let mut key = HKEY::default();
        let create_result = RegCreateKeyExW(
            HKEY_CURRENT_USER,
            w!("Control Panel\\Desktop"),
            Some(0),
            None,
            windows::Win32::System::Registry::REG_OPTION_NON_VOLATILE,
            windows::Win32::System::Registry::KEY_SET_VALUE,
            None,
            &raw mut key,
            None,
        );
        if create_result != windows::Win32::Foundation::ERROR_SUCCESS {
            return Err(format!(
                "Failed to open registry key for UserPreferencesMask: {create_result:?}"
            ));
        }

        let best_appearance_mask: [u8; 8] = [0x9E, 0x3E, 0x07, 0x80, 0x12, 0x00, 0x00, 0x00];
        let set_result = RegSetValueExW(
            key,
            w!("UserPreferencesMask"),
            Some(0),
            REG_BINARY,
            Some(&best_appearance_mask),
        );
        let _ = RegCloseKey(key);

        if set_result != windows::Win32::Foundation::ERROR_SUCCESS {
            return Err(format!("Failed to set UserPreferencesMask: {set_result:?}"));
        }
    }

    Ok(())
}
