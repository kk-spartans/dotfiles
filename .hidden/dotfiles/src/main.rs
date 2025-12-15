// Cargo.toml:
//
// [package]
// name = "win_tweaks"
// version = "0.1.0"
// edition = "2021"
//
// [dependencies]
// windows = { version = "0.58", features = [
//   "Win32_UI_Shell",
//   "Win32_UI_WindowsAndMessaging",
//   "Win32_System_SystemInformation",
//   "Win32_System_Registry",
//   "Win32_Foundation",
//   "Win32_Security",
//   "Win32_System_Com",
//   "Win32_System_WinRT",
//   "Win32_System_WinRT_WindowsFoundation",
//   "Win32_System_WinRT_WindowsSystem",
//   "Win32_System_WinRT_WindowsSystemUserProfile",
// ] }
// dirs = "5"

mod taskbar;
mod mouse;
mod wallpaper;
mod dark_mode;
mod snap_button;

use std::path::PathBuf;
use dirs::home_dir;
use windows::core::Result as WinResult;

use taskbar::set_taskbar_autohide;
use mouse::set_mouse_accel;
use wallpaper::{set_wallpaper_desktop, set_wallpaper_lock_screen};
use dark_mode::enable_dark_mode;
use snap_button::enable_snap_to_default_button;

fn main() -> WinResult<()> {
    // Build wallpaper path: <userhome>\wallpaper.jpg
    let mut path: PathBuf = home_dir().expect("No home dir?");
    path.push("wallpaper.jpg");
    let path_str = path.to_string_lossy().to_string();

    // 0. Enable taskbar autohide
    if let Err(e) = set_taskbar_autohide(true) {
        eprintln!("Failed to set taskbar autohide: {}", e);
    }

    // 1. Disable mouse acceleration
    if let Err(e) = set_mouse_accel(false) {
        eprintln!("Failed to set mouse acceleration: {}", e);
    }

    // 2. Set wallpaper for desktop
    if let Err(e) = set_wallpaper_desktop(&path_str) {
        eprintln!("Failed to set wallpaper: {}", e);
    }

    // 3. Attempt lock-screen wallpaper (no-op in plain desktop exe, see comments)
    let _ = set_wallpaper_lock_screen(&path_str);

    // 4. Turn on dark mode (registry-based)
    if let Err(e) = enable_dark_mode() {
        eprintln!("Failed to enable dark mode: {}", e);
    }

    // 5. Enable auto-move mouse to default button
    if let Err(e) = enable_snap_to_default_button(true) {
        eprintln!("Failed to set snap to default button: {}", e);
    }

    println!("Settings configuration complete!");
    Ok(())
}
