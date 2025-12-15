use windows::core::Result as WinResult;
use windows::Win32::UI::WindowsAndMessaging::{
    SystemParametersInfoW, SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS, SPI_GETMOUSE, SPI_SETMOUSE, SPIF_SENDCHANGE,
};

pub fn set_mouse_accel(enabled: bool) -> WinResult<()> {
    unsafe {
        let mut mouse_params = [0i32; 3];

        // Get current mouse settings
        let _ = SystemParametersInfoW(
            SPI_GETMOUSE,
            mouse_params.len() as u32,
            Some(mouse_params.as_mut_ptr() as *mut _),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS(0),
        );

        // mouse_params[2] is acceleration flag: 0 off, 1 on. [web:7]
        mouse_params[2] = if enabled { 1 } else { 0 };

        SystemParametersInfoW(
            SPI_SETMOUSE,
            mouse_params.len() as u32,
            Some(mouse_params.as_mut_ptr() as *mut _),
            SPIF_SENDCHANGE,
        )?;
    }

    Ok(())
}
