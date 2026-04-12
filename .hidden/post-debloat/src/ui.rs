use windows::Win32::Foundation::LPARAM;
use windows::Win32::UI::Shell::{
    ABM_GETSTATE, ABM_SETSTATE, ABS_ALWAYSONTOP, ABS_AUTOHIDE, APPBARDATA, SHAppBarMessage,
};
use windows::Win32::UI::WindowsAndMessaging::{
    SPI_SETSNAPTODEFBUTTON, SPIF_SENDCHANGE, SystemParametersInfoW,
};
use windows::core::Result as WinResult;

#[allow(clippy::cast_possible_wrap)]
pub fn set_taskbar_autohide(enable: bool) {
    unsafe {
        let mut abd = APPBARDATA {
            cbSize: u32::try_from(std::mem::size_of::<APPBARDATA>()).unwrap(),
            ..Default::default()
        };

        let state = u32::try_from(SHAppBarMessage(ABM_GETSTATE, &raw mut abd)).unwrap();

        let mut new_state = state & ABS_ALWAYSONTOP;
        if enable {
            new_state |= ABS_AUTOHIDE;
        }

        abd.lParam = LPARAM(new_state as isize);
        SHAppBarMessage(ABM_SETSTATE, &raw mut abd);
    }
}

pub fn enable_snap_to_default_button(enable: bool) -> WinResult<()> {
    unsafe {
        let flag: u32 = u32::from(enable);
        SystemParametersInfoW(SPI_SETSNAPTODEFBUTTON, flag, None, SPIF_SENDCHANGE)?;
    }
    Ok(())
}
