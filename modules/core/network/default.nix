{
  self,
  host,
  pkgs,
  ...
}:
let
  inherit (import "${self}/hosts/${host}/variables.nix") hostname;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH (Secure Shell) - remote access
        80 # HTTP - web traffic
        443 # HTTPS - encrypted web traffic
      ];
      allowedUDPPorts = [ ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
