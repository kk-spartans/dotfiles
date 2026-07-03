{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.vencord.enable = true;
    vesktop.enable = true;

    quickCss = ''
       @import url(https://capnkitten.github.io/BetterDiscord/Themes/Translucence/css/source.css);
       @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-pink.theme.css");
       @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono&display=swap');

       :root {
      --app-bg: url(https://upload.wikimedia.org/wikipedia/commons/8/8c/Transparent.png);
      --app-margin: 0px;
      --app-blur: 12px;
      --main-content-opacity: 0.28;
      --sidebar-opacity: 0.22;
      --popout-color: rgba(0,0,0,0.55);
      --popout-blur: 14px;
      --accent-hue: 316;
      --accent-saturation: 50%;
      --accent-lightness: 78%;
      --accent-opacity: 1;
      --accent-text-color: #000;
      --mention-hue: var(--accent-hue);
      --mention-saturation: var(--accent-saturation);
      --mention-lightness: var(--accent-lightness);
      --mention-opacity: 1;
      --reply-hue: 316;
      --reply-saturation: 73.8%;
      --reply-lightness: 69.0%;
      --reply-opacity: 1;

      --sidebar-color: rgba(0,0,0,0.4);
      --main-content-color: rgba(0,0,0,0.34);

      --card-color: rgba(0,0,0,0.4);
      --card-color-hover: rgba(0,0,0,0.5);
      --card-color-select: rgba(0,0,0,0.7);

      --button-action-color: #000;

      --interactive-normal: #aaa;
      --interactive-hover: #ddd;
      --interactive-active: #fff;
      --interactive-muted: #777;

      --background-modifier-hover: rgba(255,255,255,0.075);
      --background-modifier-selected: rgba(255,255,255,0.125);
       }

       * {
         font-family: 'JetBrains Mono', monospace !important;
       }

       .appMount__51fd7 * {
         text-shadow: none !important;
       }

       .appMount__51fd7 svg {
         filter: none !important;
       }

       .content__5e434 {
         backdrop-filter: blur(var(--app-blur)) !important;
       }

       .sidebar__5e434 {
         background-color: rgba(0, 0, 0, var(--sidebar-opacity)) !important;
       }

       .chat_f75fb0,
       .noChannel__01d5c {
         background-color: rgba(0, 0, 0, var(--main-content-opacity)) !important;
       }

       .wrapper__09ecc,
       .message__5126c {
         background-color: transparent !important;
         box-shadow: none !important;
       }

       .wrapper__09ecc:hover,
       .wrapper__09ecc.selected_fd9051,
       .wrapper__09ecc.mentioned__58017,
       .wrapper_c19a55,
       .wrapper_c19a55:hover,
       .wrapper_c19a55.cozy_c19a55,
       .wrapper_c19a55.compact_c19a55,
       .wrapper_c19a55.mentioned__5126c,
       .wrapper_c19a55.replying__5126c {
         background-color: transparent !important;
         box-shadow: none !important;
       }

       .membersWrap_c8ffbb,
       .container_c8ffbb,
       .members_c8ffbb,
       .members_c8ffbb > div,
       .member__5d473 {
         background-color: transparent !important;
       }

       .panels__5e434,
       .container__9293f.themed__9293f {
         background-color: transparent !important;
       }

       .container__9293f {
         background-color: transparent !important;
         box-shadow: 0 -1px 0 rgba(255, 255, 255, 0.06) !important;
       }

       .container_bd9e38:before,
       .toolbar_bba883,
       .jumpToPresentBar__0f481,
       .bd-notice,
       .bd-notification,
       .bd-modal-root:before,
       .ChannelDms-channelpopout-popout:before {
         backdrop-filter: blur(var(--popout-blur)) !important;
       }

       .channelTextArea__74017,
       .wrapper__44df5,
       .channelTextArea__74017 .scrollableContainer__74017,
       .wrapper__44df5 .scrollableContainer__74017,
       .channelTextArea__74017 .placeholder__1b31f,
       .wrapper__44df5 .placeholder__1b31f,
       .channelTextArea__74017 .editor__1b31f,
       .wrapper__44df5 .editor__1b31f,
       .channelTextAreaDisabled__74017 .scrollableContainer__74017,
       .channelAppLauncher_e6e74f .button_e6e74f,
       .spamBanner_a2eac3 {
         background-color: transparent !important;
         background: transparent !important;
         box-shadow: none !important;
         border: none !important;
         border-radius: 0 !important;
         margin: 0 !important;
         padding: 0 !important;
         opacity: 1 !important;
       }
    '';

    config = {
      frameless = true;
      transparent = true;
      useQuickCss = true;

      enableReactDevtools = true;
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = true;

      plugins = {
        alwaysAnimate.enable = true;
        messageLogger.enable = true;
        noTypingAnimation.enable = true;
        messageClickActions = {
          enable = true;
          enableDoubleClickToEdit = true;
        };
      };
    };
  };
}
