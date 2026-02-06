{ config, pkgs, inputs, username, ... }:
let
  flake = "${config.home.homeDirectory}/nixos-config#laptop";
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    # wofi = "wofi";
    rofi = "rofi";
    foot = "foot";
    niri = "niri";
    noctalia = "noctalia";
    waybar = "waybar";
    fish = "fish";
  };
in
{
  imports = [
    ./modules/theme.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";
  #programs.bash = {
  #  enable = true;
  #  shellAliases = {
  #    btw = "echo i use hyprland btw";
  #    vim = "nvim";
  #  };
  #  initExtra = ''
  #    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
  #    nitch
  #  '';
  #};

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Michael Ruppen";
        email = "michael.ruppen@pm.me";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    neovim
    ripgrep
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
  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

}
