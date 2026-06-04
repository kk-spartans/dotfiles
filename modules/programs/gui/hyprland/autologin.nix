{
  home-manager.users.kk-spartans.programs.fish.loginShellInit = ''
    tty | rg -q "/dev/tty1"
    if test $status -eq 0
      uwsm start default
    end
  '';
  services.getty.extraArgs = [
    "--noclear"
  ];
}
