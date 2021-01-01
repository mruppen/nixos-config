{
  config,
  pkgs,
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
  };
in {
  imports = [
    ./modules/theme.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

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
      credential.helper="store";
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
    jetbrains.rider
    (
      with dotnetCorePackages;
        combinePackages [
          sdk_10_0-bin
          sdk_8_0-bin
        ]
    )
    dotnet-ef
    azure-cli
    azure-cli-extensions.ssh
    azure-cli-extensions.bastion
    terraform
    ardour
    openssl
  ];

  xdg.configFile =
    builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
