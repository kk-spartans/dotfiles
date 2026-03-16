use std::process::Command;

const DO_NOTHING: u32 = 0;
const HIBERNATE: u32 = 2;
const SHUT_DOWN: u32 = 3;

pub fn apply_power_settings() -> Result<(), String> {
    run_powercfg(&["/hibernate", "on"])?;

    let schemes = list_power_schemes()?;
    if schemes.is_empty() {
        return Err("Failed to find any power schemes".to_string());
    }

    let active_scheme = active_power_scheme()?;

    for scheme in &schemes {
        set_scheme_value(scheme, true, "SUB_BUTTONS", "PBUTTONACTION", SHUT_DOWN)?;
        set_scheme_value(scheme, false, "SUB_BUTTONS", "PBUTTONACTION", SHUT_DOWN)?;
        set_scheme_value(scheme, true, "SUB_BUTTONS", "SBUTTONACTION", HIBERNATE)?;
        set_scheme_value(scheme, false, "SUB_BUTTONS", "SBUTTONACTION", HIBERNATE)?;
        set_scheme_value(scheme, true, "SUB_BUTTONS", "LIDACTION", DO_NOTHING)?;
        set_scheme_value(scheme, false, "SUB_BUTTONS", "LIDACTION", DO_NOTHING)?;
        set_scheme_value(scheme, true, "SUB_VIDEO", "VIDEOIDLE", DO_NOTHING)?;
    }

    run_powercfg(&["/setactive", &active_scheme])?;

    Ok(())
}

fn active_power_scheme() -> Result<String, String> {
    let output = run_powercfg(&["/getactivescheme"])?;

    parse_guids(&output)
        .into_iter()
        .next()
        .ok_or_else(|| format!("Failed to parse active power scheme from output: {output}"))
}

fn list_power_schemes() -> Result<Vec<String>, String> {
    let output = run_powercfg(&["/list"])?;
    let schemes = parse_guids(&output);

    if schemes.is_empty() {
        return Err(format!(
            "Failed to parse power schemes from output: {output}"
        ));
    }

    Ok(schemes)
}

fn set_scheme_value(
    scheme: &str,
    plugged_in: bool,
    subgroup: &str,
    setting: &str,
    value: u32,
) -> Result<(), String> {
    let command = if plugged_in {
        "/setacvalueindex"
    } else {
        "/setdcvalueindex"
    };
    let value = value.to_string();

    run_powercfg(&[command, scheme, subgroup, setting, &value]).map(|_| ())
}

fn run_powercfg(args: &[&str]) -> Result<String, String> {
    let output = Command::new("powercfg")
        .args(args)
        .output()
        .map_err(|e| format!("Failed to run powercfg with args {args:?}: {e}"))?;

    if output.status.success() {
        return Ok(String::from_utf8_lossy(&output.stdout).trim().to_string());
    }

    let stdout = String::from_utf8_lossy(&output.stdout).trim().to_string();
    let stderr = String::from_utf8_lossy(&output.stderr).trim().to_string();

    Err(format!(
        "powercfg {:?} failed with {}. stdout: {} stderr: {}",
        args, output.status, stdout, stderr
    ))
}

fn parse_guids(output: &str) -> Vec<String> {
    let mut guids = Vec::new();

    for token in output.split_whitespace() {
        let normalized = token.trim_matches(|c: char| matches!(c, '(' | ')' | '*' | ':' | ','));

        if is_guid(normalized) && !guids.iter().any(|guid| guid == normalized) {
            guids.push(normalized.to_string());
        }
    }

    guids
}

fn is_guid(value: &str) -> bool {
    if value.len() != 36 {
        return false;
    }

    for (index, character) in value.chars().enumerate() {
        let is_hyphen = matches!(index, 8 | 13 | 18 | 23);
        if is_hyphen {
            if character != '-' {
                return false;
            }
        } else if !character.is_ascii_hexdigit() {
            return false;
        }
    }

    true
}
