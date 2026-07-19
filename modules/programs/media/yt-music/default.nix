{ inputs, pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      programs.youtubemusic = {
        enable = true;
        package = pkgs.youtubemusic;
      };
    }
  ];
}
