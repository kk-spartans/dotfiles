use std::process::Command;

use windows::Win32::UI::WindowsAndMessaging::{
    SystemParametersInfoW, SPIF_SENDCHANGE, SPIF_UPDATEINIFILE, SYSTEM_PARAMETERS_INFO_ACTION,
    SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS,
};

const SPI_GETTOUCHPADPARAMETERS: u32 = 0x00AE;
const SPI_SETTOUCHPADPARAMETERS: u32 = 0x00AF;

#[repr(C)]
#[derive(Default)]
struct TouchpadParameters {
    version_number: u32,
    max_supported_contacts: u32,
    legacy_touchpad_features: u32,
    flags1: u32,
    flags2: u32,
    sensitivity_level: u32,
    cursor_speed: u32,
    feedback_intensity: u32,
    click_force_sensitivity: u32,
    right_click_zone_width: u32,
    right_click_zone_height: u32,
}

impl TouchpadParameters {
    fn set_flag2(&mut self, bit: u32, value: bool) {
        if value {
            self.flags2 |= 1u32 << bit;
        } else {
            self.flags2 &= !(1u32 << bit);
        }
    }

    fn set_tap_enabled(&mut self, value: bool) {
        self.set_flag2(2, value);
    }

    fn set_tap_and_drag_enabled(&mut self, value: bool) {
        self.set_flag2(3, value);
    }

    fn set_two_finger_tap_enabled(&mut self, value: bool) {
        self.set_flag2(4, value);
    }

    fn set_right_click_zone_enabled(&mut self, value: bool) {
        self.set_flag2(5, value);
    }

    fn set_pan_enabled(&mut self, value: bool) {
        self.set_flag2(7, value);
    }

    fn set_zoom_enabled(&mut self, value: bool) {
        self.set_flag2(8, value);
    }

    fn set_scroll_direction_reversed(&mut self, value: bool) {
        self.set_flag2(9, value);
    }
}

pub fn apply_touchpad_api_settings() -> Result<bool, String> {
    let api_applied = try_apply_touchpad_api_settings();

    refresh_touchpad_settings()?;

    Ok(api_applied)
}

#[allow(clippy::cast_possible_truncation)]
fn try_apply_touchpad_api_settings() -> bool {
    unsafe {
        let mut parameters = TouchpadParameters {
            version_number: 1,
            ..TouchpadParameters::default()
        };
        let size = std::mem::size_of::<TouchpadParameters>() as u32;

        if SystemParametersInfoW(
            SYSTEM_PARAMETERS_INFO_ACTION(SPI_GETTOUCHPADPARAMETERS),
            size,
            Some((&raw mut parameters).cast()),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS(0),
        )
        .is_err()
        {
            return false;
        }
        parameters.sensitivity_level = 3;
        parameters.set_tap_enabled(true);
        parameters.set_two_finger_tap_enabled(true);
        parameters.set_tap_and_drag_enabled(true);
        parameters.set_right_click_zone_enabled(true);
        parameters.set_pan_enabled(true);
        parameters.set_zoom_enabled(true);
        parameters.set_scroll_direction_reversed(false);

        SystemParametersInfoW(
            SYSTEM_PARAMETERS_INFO_ACTION(SPI_SETTOUCHPADPARAMETERS),
            size,
            Some((&raw mut parameters).cast()),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS(SPIF_UPDATEINIFILE.0 | SPIF_SENDCHANGE.0),
        )
        .is_ok()
    }
}

fn refresh_touchpad_settings() -> Result<(), String> {
    let status = Command::new("rundll32.exe")
        .args(["user32.dll,UpdatePerUserSystemParameters"])
        .status()
        .map_err(|e| format!("Failed to refresh touchpad settings: {e}"))?;

    if !status.success() {
        return Err(format!(
            "Failed to refresh touchpad settings: process exited with {status}"
        ));
    }

    Ok(())
}
