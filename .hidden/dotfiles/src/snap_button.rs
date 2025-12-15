use windows::core::Result as WinResult;
use windows::Win32::UI::WindowsAndMessaging::{
    SystemParametersInfoW, SPI_SETSNAPTODEFBUTTON, SPIF_SENDCHANGE,
};

pub fn enable_snap_to_default_button(enable: bool) -> WinResult<()> {
    unsafe {
        let flag: u32 = if enable { 1 } else { 0 };
        SystemParametersInfoW(
            SPI_SETSNAPTODEFBUTTON,
            flag,
            None,
            SPIF_SENDCHANGE,
        )?;
    }
    Ok(())
}
