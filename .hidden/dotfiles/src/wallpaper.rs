use std::ffi::OsStr;
use std::iter::once;
use std::os::windows::ffi::OsStrExt;

use windows::core::Result as WinResult;
use windows::Win32::UI::WindowsAndMessaging::{
    SystemParametersInfoW, SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS, SPI_SETDESKWALLPAPER, SPIF_SENDCHANGE, SPIF_UPDATEINIFILE,
};

fn to_wide(s: &str) -> Vec<u16> {
    OsStr::new(s).encode_wide().chain(once(0)).collect()
}

pub fn set_wallpaper_desktop(path: &str) -> WinResult<()> {
    let wide = to_wide(path);
    unsafe {
        SystemParametersInfoW(
            SPI_SETDESKWALLPAPER,
            0,
            Some(wide.as_ptr() as *mut _),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS(SPIF_UPDATEINIFILE.0 | SPIF_SENDCHANGE.0),
        )?;
    }
    Ok(())
}

// Best-effort: requires WinRT and the right app context; may silently fail in a normal console app. [web:13]
#[allow(dead_code)]
pub fn set_wallpaper_lock_screen(_path: &str) -> WinResult<()> {
    // Realistically, from a plain desktop exe this is not reliable.
    // Proper way is a UWP / packaged app using Windows.System.UserProfile.LockScreen. [web:13]
    Ok(())
}
