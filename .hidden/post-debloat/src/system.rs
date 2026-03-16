use std::process::Command;

pub fn enable_powershell_execution() -> Result<(), String> {
    let output = Command::new("powershell")
        .args([
            "-NoProfile",
            "-Command",
            "Set-ExecutionPolicy Unrestricted -Force",
        ])
        .output()
        .map_err(|e| format!("Failed to launch PowerShell for execution policy: {e}"))?;

    if output.status.success() {
        return Ok(());
    }

    Err(format!(
        "PowerShell execution policy command failed with {}. stderr: {}",
        output.status,
        String::from_utf8_lossy(&output.stderr).trim()
    ))
}

pub fn update_per_user_system_parameters() -> Result<(), String> {
    let status = Command::new("rundll32.exe")
        .args(["user32.dll,UpdatePerUserSystemParameters", "1,", "True"])
        .status()
        .map_err(|e| format!("Failed to update per-user system parameters: {e}"))?;

    if status.success() {
        return Ok(());
    }

    Err(format!(
        "UpdatePerUserSystemParameters exited with {status}"
    ))
}

pub fn restart_explorer() -> Result<(), String> {
    let kill_status = Command::new("taskkill")
        .args(["/F", "/IM", "explorer.exe"])
        .status()
        .map_err(|e| format!("Failed to kill explorer.exe: {e}"))?;
    if !kill_status.success() {
        return Err(format!("taskkill explorer.exe exited with {kill_status}"));
    }

    let start_status = Command::new("explorer.exe")
        .status()
        .map_err(|e| format!("Failed to start explorer.exe: {e}"))?;
    if start_status.success() {
        return Ok(());
    }

    Err(format!("explorer.exe exited with {start_status}"))
}
