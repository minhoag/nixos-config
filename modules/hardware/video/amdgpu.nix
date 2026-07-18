# This module is untested since i don't own an amd gpu!
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # vulkan-loader
      # vulkan-extension-layer
      # vulkan-validation-layers
    ];
  };
}
