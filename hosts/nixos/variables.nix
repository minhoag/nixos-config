{
  # User Configuration
  username = "wumps";
  gitUsername = "hoang.nguyen";
  gitEmail = "nhoang120899@gmail.com";
  desktop = "niri";
  terminal = "foot"; # Options: foot, kitty
  editor = "neovim"; # Options: vscode, antigravity, neovim
  browser = "firefox"; # Options: firefox, zen
  tuiFileManager = "yazi"; # Options: yazi, lf
  shell = "fish"; # Options: fish, zsh, bash
  games = true; # Whether to enable the gaming module

  # Hardware Configuration
  videoDriver = "amdgpu"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "nixos"; # Your system hostname

  # Localization
  clock24h = true; # 24H or 12H clock in waybar
  kbdLayout = "us"; # Keyboard layout
  kbdVariant = " "; # Keyboard variant (can be empty)
  consoleKeymap = "us"; # TTY keymap
}
