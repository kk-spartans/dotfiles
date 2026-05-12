{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zen-browser.profiles.default.search = {
    force = true;
    default = "unduck";
    engines = {
      unduck = {
        name = "unduck";
        urls = [
          {
            template = "https://unduck.link?q={searchTerms}";
          }
        ];
        icon = "https://unduck.link/favicon.ico";
      };

      chatgpt = {
        name = "ChatGPT";
        urls = [
          {
            template = "https://chatgpt.com?prompt={searchTerms}";
          }
        ];
        definedAliases = [ "@c" ];
      };
    };
  };
}
