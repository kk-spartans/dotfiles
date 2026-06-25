{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zen-browser = {
    profiles.default = {
      settings = {
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.download.useDownloadDir" = false;
        "browser.tabs.allow_transparent_browser" = true;
        "browser.aboutConfig.showWarning" = false;

        "general.autoScroll" = true;
        "gfx.webrender.all" = true;
        "layers.acceleration.disabled" = false;
        "layout.css.devPixelsPerPx" = 1.1;

        "toolkit.tabbox.switchByScrolling" = true;

        "mod.sameerasw.zen_transparent_sidebar_enabled" = true;
        "mod.sameerasw.zen_transparent_glance_enabled" = true;
        "mod.sameerasw.zen_bg_color_enabled" = false;
        "mod.sameerasw.zen_no_shadow" = true;
        "mod.sameerasw.zen_bg_img_enabled" = false;
        "mod.sameerasw.zen_bg_img_not_fullscreen" = false;
        "mod.sameerasw_zen_empty_tab_logo" = "0";
        "mod.sameerasw_zen_compact_sidebar_type" = "2";
        "mod.sameerasw.zen_compact_sidebar_width" = "165px";
        "mod.sameerasw.zen_tab_switch_anim" = false;
        "mod.sameerasw.zen_urlbar_zoom_anim" = false;
        "mod.sameerasw.zen_trackpad_anim" = false;
        "mod.sameerasw_zen_animations" = "1";

        "zen.ctrlTab.show-pending-tabs" = true;
        "zen.startup.smooth-scroll-in-tabs" = true;
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.animate-sidebar" = true;
        "zen.widget.linux.transparency" = true;
        "zen.tabs.vertical.right-side" = true;
        "zen.theme.content-element-separation" = 0;

        "zen.view.grey-out-inactive-windows" = false;
        "zen.view.compact.color-sidebar" = false;
        "zen.view.compact.color-toolbar" = false;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.show-sidebar-and-toolbar-on-hover" = true;
        "zen.view.compact.toolbar-flash-popup" = false;
        "zen.view.compact.should-enable-at-startup" = true;

        "sine.engine.auto-update" = false;
      };

      sine = {
        enable = true;
        mods = [
          "Transparent Zen"
          "Nebula"
          "No Gaps"
        ];
      };
    };

    policies.ExtensionSettings."{91aa3897-2634-4a8a-9092-279db23a7689}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4741120/zen_internet-3.1.2.xpi";
      installation_mode = "force_installed";
    };
  };
}
