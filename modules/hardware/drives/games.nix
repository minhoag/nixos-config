{ lib, ... }:
{
  # change according to your partition name and format
  fileSystems."/mnt/Games" = lib.mkForce {
    device = "/dev/disk/by-uuid/0aa3a390-9d56-41f3-ba93-cd4d7568dd29"; # get drive uuid from `lsblk -o UUID,LABEL,FSTYPE,MOUNTPOINT`
    fsType = "ext4";
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
