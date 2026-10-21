{ config, lib, pkgs, ... }:
let
  cfg = config.services.nixos-update;
  sudo = "/run/wrappers/bin/sudo";
  notify = "/run/current-system/sw/bin/notify-send";
in
{
  options.services.nixos-update = {
    enable = lib.mkEnableOption "Run /etc/nixos update + rebuild every 6 hours";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.nixos-update = {
      description = "Update /etc/nixos and rebuild hosts";

      serviceConfig = {
        Type = "oneshot";
        Environment = [
          "HOME=/home/kk-spartans"
          "PATH=/run/current-system/sw/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/home/kk-spartans/.nix-profile/bin"
        ];
        ExecStart = ''
          set -euo pipefail

          ${notify} "nixos-update" "starting /etc/nixos update" || true

          cd /etc/nixos
          git pull --rebase --autostash
          nix flake update
          if ! git diff --quiet; then
            git add -A
            git commit -m "chore: auto-update /etc/nixos"
            git remote set-url origin "https://x-access-token:$(gh auth token)@github.com/kk-spartans/dotfiles.git"
            git push origin main
          fi

          ${notify} "nixos-update" "rebuilding mac-pro" || true
          ${sudo} nixos-rebuild switch --flake=.#mac-pro

          # Cache the kk-spartans build on mac-pro (kk-spartans uses mac as a
          # buildMachine, so this makes its switch fast).
          nix build .#nixosConfigurations.kk-spartans

          if ssh -o BatchMode=yes -o ConnectTimeout=5 kk-spartans true 2>/dev/null; then
            ssh kk-spartans notify-send "nixos-update" "rebuilding kk-spartans" || true
            ssh kk-spartans ${sudo} nixos-rebuild switch --flake=.#kk-spartans
            ssh kk-spartans notify-send "nixos-update" "kk-spartans rebuild done" || true
          else
            ${notify} "nixos-update" "kk-spartans offline, skipped" || true
          fi

          ${notify} "nixos-update" "all done" || true
        '';
      };
    };

    systemd.user.timers.nixos-update = {
      description = "Run nixos-update every 6 hours";

      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* *:00/6:00";
        Persistent = true;
      };
    };
  };
}
