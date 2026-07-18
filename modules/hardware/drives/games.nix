{ lib, ... }:
{
  # change according to your partition name and format
  fileSystems."/mnt/Games" = lib.mkForce {
    device = "/dev/disk/by-uuid/12345678-1234-1234-1234-123456789012";
    fsType = "btrfs";
    options = [
      "rw"
      "defaults" # Default flags
      "async" # Run all operations async
      "noatime"
      "nofail"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
