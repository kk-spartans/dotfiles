use std::process::Command;

pub fn enable_powershell_execution() -> Result<(), String> {
    run_powershell(
        "Set-ExecutionPolicy Unrestricted -Force",
        "PowerShell execution policy command",
    )
    .map(|_| ())
}

pub fn install_explorer_blur_mica_latest() -> Result<(), String> {
    let script = r#"
$ErrorActionPreference = 'Stop'
$headers = @{
    'User-Agent' = 'post-debloat'
    'Accept' = 'application/vnd.github+json'
}

$apiUrl = 'https://api.github.com/repos/Maplespe/ExplorerBlurMica/releases/latest'
$release = Invoke-RestMethod -Uri $apiUrl -Headers $headers

$asset = $release.assets |
    Where-Object { $_.name -match '(?i)x64.*\.zip$' } |
    Select-Object -First 1

if (-not $asset) {
    $asset = $release.assets |
        Where-Object { $_.name -match '(?i)\.zip$' } |
        Select-Object -First 1
}

if (-not $asset) {
    throw 'No downloadable zip asset found in the latest ExplorerBlurMica release.'
}

$installDir = Join-Path $env:ProgramFiles 'ExplorerBlurMica'
$zipPath = Join-Path $env:TEMP ("ExplorerBlurMica-" + $release.tag_name + ".zip")

New-Item -Path $installDir -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $asset.browser_download_url -Headers $headers -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

$dllPath = Join-Path $installDir 'ExplorerBlurMica.dll'
if (-not (Test-Path $dllPath)) {
    throw "ExplorerBlurMica.dll not found after extraction at: $dllPath"
}

& regsvr32.exe /s $dllPath
if ($LASTEXITCODE -ne 0) {
    throw "regsvr32 failed with exit code $LASTEXITCODE"
}

Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
"#;

    run_powershell(script, "ExplorerBlurMica installation").map(|_| ())
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

fn run_powershell(script: &str, context: &str) -> Result<String, String> {
    let output = Command::new("powershell")
        .args([
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-Command",
            script,
        ])
        .output()
        .map_err(|e| format!("Failed to launch PowerShell for {context}: {e}"))?;

    let stdout = String::from_utf8_lossy(&output.stdout).trim().to_string();
    let stderr = String::from_utf8_lossy(&output.stderr).trim().to_string();

    if output.status.success() {
        return Ok(stdout);
    }

    Err(format!(
        "{context} failed with {}. stdout: {} stderr: {}",
        output.status, stdout, stderr
    ))
}
