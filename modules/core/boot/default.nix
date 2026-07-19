{ pkgs, ... }:
let
  mac-style-plymouth = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "s4rchiso-plymouth-theme";
    rev = "bc585b7f42af415fe40bece8192d9828039e6e20";
    hash = "sha256-yOvZ4F5ERPfnSlI/Scf9UwzvoRwGMqZlrHkBIB3Dm/w=";
  }) { };
in
{
  boot = {
    # Filesystems support
    supportedFilesystems = [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
    consoleLogLevel = 3;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ mac-style-plymouth ];
    };

    # Kernel Parameter Tuning for zRAM
    kernel.sysctl = {
      "vm.swappiness" = 100;
    };
    kernelParams = [
      "preempt=full" # lower latency but less throughput
      "reboot=efi"
      "quiet"
      "udev.log_level=3"
    ];

    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = false;
        maxGenerations = 5;
        secureBoot.enable = true;
      };
      timeout = 1;
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
