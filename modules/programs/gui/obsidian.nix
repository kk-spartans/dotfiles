{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [ obsidian ];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.window_rule({
      name = "obsidian-blur",
      match = { class = "^([Oo]bsidian)$" },
      blur = true,
    })
  '';

  programs.vicinae.settings.providers.applications.entrypoints.obsidian.alias = "ob";

  # Obsidian Web Clipper — moved here from zen-browser extensions
  programs.zen-browser.policies.ExtensionSettings."{4cfbf13b-f27f-4f03-91dc-2aa17644029a}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/3727203/obsidian_web_clipper-0.1.xpi";
    installation_mode = "force_installed";
  };
}
