use windows::core::{w, Result as WinResult};
use windows::Win32::Foundation::WIN32_ERROR;
use windows::Win32::System::Registry::{
    RegCreateKeyExW, RegSetValueExW, HKEY_CURRENT_USER, REG_DWORD, REG_OPTION_NON_VOLATILE,
    REG_OPEN_CREATE_OPTIONS, REG_SAM_FLAGS, REG_CREATE_KEY_DISPOSITION, KEY_WRITE,
};

pub fn enable_dark_mode() -> WinResult<()> {
    // There is no clean Win32 "turn on dark mode" API; everyone uses these undocumented registry values. [web:9][web:19]
    unsafe {
        let subkey = w!("Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize");
        let mut hkey = Default::default();
        let mut disposition = REG_CREATE_KEY_DISPOSITION(0);

        let err = RegCreateKeyExW(
            HKEY_CURRENT_USER,
            subkey,
            Some(0),
            None,
            REG_OPEN_CREATE_OPTIONS(REG_OPTION_NON_VOLATILE.0),
            REG_SAM_FLAGS(KEY_WRITE.0),
            None,
            &mut hkey,
            Some(&mut disposition),
        );
        if err != WIN32_ERROR(0) {
            eprintln!("Failed to open registry key: {:?}", err);
            return Err(windows::core::Error::from(err));
        }

        let zero: u32 = 0;

        let name1 = w!("AppsUseLightTheme");
        let err = RegSetValueExW(
            hkey,
            name1,
            Some(0),
            REG_DWORD,
            Some(std::slice::from_raw_parts(
                &zero as *const u32 as *const u8,
                std::mem::size_of::<u32>(),
            )),
        );
        if err != WIN32_ERROR(0) {
            return Err(windows::core::Error::from(err));
        }

        let name2 = w!("SystemUsesLightTheme");
        let err = RegSetValueExW(
            hkey,
            name2,
            Some(0),
            REG_DWORD,
            Some(std::slice::from_raw_parts(
                &zero as *const u32 as *const u8,
                std::mem::size_of::<u32>(),
            )),
        );
        if err != WIN32_ERROR(0) {
            return Err(windows::core::Error::from(err));
        }
    }

    Ok(())
}
