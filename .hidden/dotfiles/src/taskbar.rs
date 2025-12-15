use windows::core::Result as WinResult;
use windows::Win32::Foundation::LPARAM;
use windows::Win32::UI::Shell::{SHAppBarMessage, APPBARDATA, ABM_GETSTATE, ABM_SETSTATE, ABS_ALWAYSONTOP, ABS_AUTOHIDE};

pub fn set_taskbar_autohide(enable: bool) -> WinResult<()> {
    unsafe {
        let mut abd = APPBARDATA::default();
        abd.cbSize = std::mem::size_of::<APPBARDATA>() as u32;

        let state = SHAppBarMessage(ABM_GETSTATE, &mut abd) as u32;

        let mut new_state = state & ABS_ALWAYSONTOP;
        if enable {
            new_state |= ABS_AUTOHIDE;
        }

        abd.lParam = LPARAM(new_state as isize);
        SHAppBarMessage(ABM_SETSTATE, &mut abd);
    }

    Ok(())
}
