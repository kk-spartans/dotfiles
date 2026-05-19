{
  config,
  pkgs,
  inputs,
  ...
}:
{

  # you can tell i spent a lot of time formatting this

  programs.vscode.profiles.default.userSettings = {
    editor = {
      minimap = {
        enabled = true;
        autohide = "mouseover";
      };

      autoClosingDelete = "always";
      autoClosingBrackets = "always";
      autoClosingComments = "always";
      autoClosingOvertype = "always";
      autoClosingQuotes = "always";
      mouseWheelZoom = true;
      cursorSmoothCaretAnimation = "on";
      formatOnSave = true;
      cursorBlinking = "solid";
      fontLigatures = true;
      smoothScrolling = true;
      fontFamily = "JetBrainsMono Nerd Font";
      unicodeHighlight.invisibleCharacters = true;
    };

    workbench = {
      sideBar.location = "right";
      activityBar.location = "top";
      editor.splitInGroupLayout = "vertical";
      secondarySideBar.defaultVisibility = "hidden";
      list.mouseWheelScrollSensitivity = 1.5;
      iconTheme = "symbols";
      startupEditor = "none";
      colorTheme = "Vesper Black";
      colorCustomizations = { };
      editor.empty.hint = "hidden";
    };

    terminal.integrated = {
      enableMultiLinePasteWarning = "never";
      initialHint = false;
      gpuAcceleration = "off";
      cursorStyle = "line";
      cursorBlinking = true;
      smoothScrolling = true;
    };

    window = {
      commandCenter = true;
      autoDetectColorScheme = false;
      titleBarStyle = "custom";
      controlsStyle = "custom";
    };

    files = {
      autoSave = "afterDelay";
      eol = "\n";
      insertFinalNewline = true;
      autoSaveDelay = 10;
    };

    extensions = {
      experimental.affinity = {
        "vscodevim.vim" = 1;
      };

      ignoreRecommendations = true;
    };

    python.analysis = {
      typeCheckingMode = "off";
      autoFormatStrings = true;
    };

    explorer = {
      confirmDragAndDrop = false;
      confirmDelete = false;
    };

    git = {
      autofetch = true;
      openRepositoryInParentFolders = "never";
      confirmSync = false;
    };

    github.copilot.nextEditSuggestions = {
      enabled = true;
      eagerness = "high";
    };

    security.workspace.trust.untrustedFiles = "open";
    diffEditor.hideUnchangedRegions.enabled = true;
    chat.agent.maxRequests = 1000;
    vim.useCtrlKeys = false;
    custom-ui-style.font.sansSerif = "JetBrainsMono Nerd Font";
    nix.formatterPath = "nixfmt";
    redhat.telemetry.enabled = false;
  };
}
