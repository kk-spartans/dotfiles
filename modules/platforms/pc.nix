{
  config,
  pkgs,
  inputs,
  lib,
  pc,
  ...
}:
{
  imports = lib.optionals pc [
    ../user/gtk/gtk.nix
    ../programs/gui/gui.nix
    inputs.hex.nixosModules.hex
  ];

  home-manager.users.kk-spartans = lib.mkIf pc {
    imports = [ inputs.hex.homeManagerModules.hex ];
    programs.hex = {
      enable = true;
      autostart = true;
      systemdTarget = "graphical-session.target";
      # Hex dictation toggle is bound to CTRL + Space (and CTRL + Shift + Space
      # for toggle without processing) in
      # modules/programs/gui/hyprland/hypr/binds.nix (hl.bind).
      # hex 3.3.0 has a failing test (meetings.opencode_model names no setting)
      package = inputs.hex.packages.${pkgs.stdenv.hostPlatform.system}.hex.overrideAttrs (old: {
        doCheck = false;
      });
      # Declarative settings (see hex docs/nix.md).
      # cancel_hotkey stays live: a lone Escape needs Labs › Special keys alone.
      # shortcut = "control+option+space";
      # model = "parakeet_v3";
      # language = "en";
      # installModel = true;
      settings = {
        avoid_bluetooth_microphone = true;
        "capture.bundle_days" = 30;
        "capture.capsule_flow" = "list";
        "capture.enabled" = true;
        "capture.folder" = null;
        "capture.hotkey" = "f9";
        "capture.media_days" = 7;
        "capture.routing" = {
          agentHost = null;
          agentOpencode = null;
          aliases = { };
          apps = { };
          autoSend = "rules";
          delivery = "steer";
          jev = null;
          jevApiKey = null;
          jevRouting = false;
          refusedRules = [ ];
          sendCaptures = true;
          servers = { };
          sites = { };
          smartRouting = false;
          undoWindowSec = null;
        };
        "capture.show_overlays_in_recordings" = false;
        "capture.transcriber" = "parakeet";
        dictation_hotkey = "option+space";
        "dictation_processing.default_mode" = {
          applications = [ ];
          browser_hosts = [ ];
          name = "Global";
          post_processing = {
            deadline_seconds = 30;
            enabled = true;
            model = "groq/qwen/qwen3.8-27b";
            prompt = "Rewrite the transcript into clear, natural text while preserving the speaker's intended meaning.";
            variant = null;
          };
          replacements = [ ];
          transformations = [ "lowercase" ];
        };
        "dictation_processing.modes" = [ ];
        double_tap_lock = true;
        double_tap_only = false;
        enable_on_launch = true;
        "experimental.hex_microphone" = true;
        "experimental.hex_microphone_comfort_noise" = true;
        "experimental.hex_microphone_mode" = "muffled";
        "experimental.hex_microphone_strength" = 1;
        gnome_keyboard_shortcuts = false;
        history_retention = "week";
        indicator_position = "bottom";
        "labs.benchmark_details" = true;
        "labs.copy_only" = false;
        "labs.filler_words" = true;
        "labs.history_stats" = true;
        "labs.keep_on_clipboard" = false;
        "labs.keep_recordings" = true;
        "labs.live_chapters" = true;
        "labs.live_text" = true;
        "labs.meeting_summary_model" = false;
        "labs.model_in_place" = true;
        "labs.mouse_shortcuts" = false;
        "labs.movable_meeting_capsules" = false;
        "labs.output_fixes" = true;
        "labs.parakeet_ultra" = true;
        "labs.picker_active_first" = true;
        "labs.picker_downloaded" = true;
        "labs.picker_sort_filter" = true;
        "labs.playground" = false;
        "labs.recent_dictations" = false;
        "labs.restore_shortcut_default" = true;
        "labs.second_dictation_shortcut" = false;
        "labs.section_key_alone" = false;
        "labs.sided_modifier_chords" = false;
        "labs.skip_pauses" = true;
        "labs.smart_spacing" = false;
        "labs.spoken_formatting" = true;
        "labs.spoken_symbols" = true;
        "labs.standalone_special_keys" = false;
        "labs.stop_when_call_ends" = false;
        "labs.subtitle_export" = true;
        "labs.tap_or_hold" = false;
        "labs.unload_idle" = false;
        "labs.unload_idle_minutes" = "15";
        "labs.vocabulary_biasing" = true;
        "meetings.enabled" = true;
        "meetings.opencode_model" = null;
        "meetings.output_folder" = null;
        "meetings.providers" = [ ];
        "meetings.recording_indicator_corner" = "top_right";
        "meetings.retention" = "forever";
        "meetings.show_recording_indicator" = true;
        "meetings.summarize_with_apple_intelligence" = true;
        "meetings.summarize_with_opencode" = false;
        microphone = "Default ALSA Output (currently PipeWire Media Server)";
        paste_last_hotkey = "control+option+v";
        paste_with_shift = false;
        pause_browser_media = false;
        raw_dictation_hotkey = null;
        recording_audio_behavior = "duck";
        recording_duck_volume = 0.2;
        release_microphone_while_idle = true;
        second_dictation_hotkey = null;
        shortcut_mode = "hold";
        sound_effect_volume = 0.5;
        sound_effects = true;
        sound_theme = "classic";
        "transcription.language" = "en";
        "transcription.model" = "parakeet_unified_en";
        transcription_device = "auto";
        ui_language = null;
        "updates.channel" = null;
        vocabulary_boost = "normal";
      };
    };
  };

  # The wifi tray icon. blueman 2.4 dropped its NetworkManager applet, and
  # nixpkgs dropped networking.networkmanager.applet along with it, so
  # nm-applet gets wired up by hand here. Without it the desktop host has
  # a bluetooth tray icon and no network one. Desktop hosts only --
  # mac-pro imports this module with pc = false and gets nothing.
  systemd.user.services.nm-applet = lib.mkIf pc {
    description = "NetworkManager tray applet";
    documentation = [ "https://networkmanager.pages.freedesktop.org/NetworkManager/Applet/" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    restartTriggers = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.networkmanagerapplet;
      Restart = "on-failure";
      RestartSec = 5;
      Slice = "app.slice";
    };
  };
}
