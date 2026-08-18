{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: let
  flake = "${config.home.homeDirectory}/nixos-config#laptop";
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    rofi = "rofi";
    foot = "foot";
    niri = "niri";
    noctalia = "noctalia";
    waybar = "waybar";
    fish = "fish";
    sway = "sway";
  };
in {
  imports = [
    ./modules/theme.nix
    inputs.zen-browser.homeModules.beta
    inputs.reaper-flake.homeModules.reaper
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Michael Ruppen";
        email = "michael.ruppen@pm.me";
        credential.helper = "${
          pkgs.git.override {withLibsecret = true;}
        }/bin/git-credential-libsecret";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  programs.zen-browser.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      kamadorueda.alejandra
      hashicorp.terraform
      ms-dotnettools.vscodeintellicode-csharp
      ms-dotnettools.csharp
      ms-vscode.powershell
      zaaack.markdown-editor
    ];
  };

  programs.reaper = {
    enable = true;

    packages = with pkgs; [
      freetype
      libpng
      zlib
      fontconfig
      libepoxy
      gtk3
      cairo
      glib
    ];

    extensions = {
      reapack.enable = true;
      sws = {
        enable = true;
        colors = [
          "#F5E0E6"
          "#F2CDCD"
          "#F5C2E7"
          "#CBA6F7"
        ];
      };

      reapack = {
        enable = true;
        repositories = [
          {
            name = "Bird-Bird";
            url = "https://github.com/Bird-Bird/ReaScript_Testing/raw/main/index.xml";
          }
          {
            name = "reaper-keys";
            url = "https://raw.githubusercontent.com/gwatcha/reaper-keys/master/index.xml";
          }
        ];

        packages = [
        {
          repository = "ReaTeam Extensions";
          category = "API";
          name = "js_ReaScriptAPI.ext";
        }
        {
          repository = "ReaTeam Extensions";
          category = "API";
          name = "reaper_imgui.ext";
        }
        {
          repository = "reaper-keys";
          category = "Scripts";
          name = "install-reaper-keys.lua";
        }
      ];                            

      synchronizeOnActivation = true;
    };

    theme = {
      active = "Reapertips Theme.ReaperThemeZip";
      packages = [
        inputs.reaper-flake.packages.${pkgs.system}.reapertips-theme
        inputs.reaper-flake.packages.${pkgs.system}.smooth6-theme
      ];
      colorThemes = [./themes/MyTheme.ReaperThemeZip];
    };

    # Linux SWELL UI colors. This does not affect macOS's native UI.
    swell.colortheme = {
      enable = true;
      preset = inputs.reaper-flake.packages.${pkgs.system}.reapertips-theme;
    };

    preferences = {
      general.startupSettings.showSplashScreenOnStartup = false;
      project.trackSendDefaults.trackVolumeFaderGain = -10.0;
      plugIns.reascript.python.enable = true;
    };
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    tree-sitter
    fd
    nil
    nixpkgs-fmt
    nodejs
    gcc
    wofi
    nitch
    rofi
    pcmanfm
    bitwig-studio
    proton-pass
    signal-desktop
    onlyoffice-desktopeditors
    dnslookup
    #jetbrains.rider
    (
      with dotnetCorePackages;
        combinePackages [
          sdk_10_0-bin
          sdk_8_0-bin
        ]
    )
    dotnet-ef
    roslyn-ls
    azure-cli
    azure-cli-extensions.ssh
    azure-cli-extensions.bastion
    terraform
    openssl
    nerd-fonts.jetbrains-mono
    testdisk
    sparrow
    qjackctl
    devenv
    markdownlint-cli2
    wl-clipboard
    teams-for-linux
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile =
    builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
