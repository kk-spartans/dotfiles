mod power;
mod registry;
mod system;
mod touchpad;
mod ui;

use std::process;

fn main() {
    if let Err(error) = run() {
        eprintln!("[ERROR] {error}");
        process::exit(1);
    }
}

fn run() -> Result<(), String> {
    println!("[START] Running post-debloat tweaks...");

    println!("[START] Setting taskbar autohide...");
    ui::set_taskbar_autohide(true);
    println!("[OK] Taskbar autohide enabled.");

    println!("[START] Enabling snap-to-default-button...");
    ui::enable_snap_to_default_button(true)
        .map_err(|e| format!("Failed to enable snap-to-default-button: {e}"))?;
    println!("[OK] Snap-to-default-button enabled.");

    println!("[START] Enabling PowerShell execution policy...");
    system::enable_powershell_execution()?;
    println!("[OK] PowerShell execution policy updated.");

    println!("[START] Applying power settings...");
    power::apply_power_settings()?;
    println!("[OK] Power settings applied.");

    println!("[START] Applying touchpad API settings...");
    if !touchpad::apply_touchpad_api_settings()? {
        println!(
            "[WARN] Touchpad API settings did not stick immediately. The Talon plan still covers the registry side."
        );
    } else {
        println!("[OK] Touchpad settings applied.");
    }

    println!("[START] Applying remaining registry tweaks...");
    registry::apply_post_debloat_registry_tweaks()?;
    println!("[OK] Remaining registry tweaks applied.");

    println!("[START] Refreshing Windows shell state...");
    system::update_per_user_system_parameters()?;
    system::restart_explorer()?;
    println!("[OK] Windows shell state refreshed.");

    println!("[OK] Post-debloat tweaks complete.");
    Ok(())
}
