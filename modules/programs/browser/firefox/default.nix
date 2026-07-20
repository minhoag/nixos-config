{ pkgs, ... }:
{
  programs.firefox.enable = true;
  environment.systemPackages = [
    pkgs.firefoxpwa
  ];
  home-manager.sharedModules = [
    ({
      programs.firefox = {
        enable = true;
        nativeMessagingHosts = [
          pkgs.firefoxpwa
        ];
      };
    })
  ];
}
