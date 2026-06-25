{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zen-browser.policies.ExtensionSettings = {
    "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4647055/catppuccin_web_file_icons-1.6.1.xpi";
      installation_mode = "force_installed";
    };
    "addon@darkreader.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4748915/darkreader-4.9.124.xpi";
      installation_mode = "force_installed";
    };
    "Librezam@Librezam" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4752025/librezam-5.9.xpi";
      installation_mode = "force_installed";
    };
    "{4cfbf13b-f27f-4f03-91dc-2aa17644029a}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/3727203/obsidian_web_clipper-0.1.xpi";
      installation_mode = "force_installed";
    };
    "{e4a8a97b-f2ed-450b-b12d-ee082ba24781}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4642595/react_developer_tools-6.1.0.xpi";
      installation_mode = "force_installed";
    };
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4772939/refined_github-26.4.20.xpi";
      installation_mode = "force_installed";
    };
    "sponsorBlocker@ajay.app" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4773757/sponsorblock-6.1.5.xpi";
      installation_mode = "force_installed";
    };
    "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4573120/surfingkeys_ff-1.17.11.xpi";
      installation_mode = "force_installed";
    };
    "firefox@tampermonkey.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4624137/tampermonkey-5.4.1.xpi";
      installation_mode = "force_installed";
    };
    "adnauseam@rednoise.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4821708/adnauseam-3.28.6.xpi";
      installation_mode = "force_installed";
    };
    "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4773733/user_agent_string_switcher-0.6.7.xpi";
      installation_mode = "force_installed";
    };

    # takes 16gbs of memory out of nowhere doing nothing, and slows down page loads *by a lot*
    # "wappalyzer@crunchlabz.com" = {
    #   install_url = "https://addons.mozilla.org/firefox/downloads/file/4782673/wappalyzer-6.12.1.xpi";
    #   installation_mode = "force_installed";
    # };
  };
}
