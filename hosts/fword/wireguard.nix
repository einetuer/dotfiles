{ config, ... }:
{
  networking.firewall.allowedUDPPorts = [
    config.networking.wg-quick.interfaces.wg0.listenPort
  ];

  sops.secrets.wireguard-private-key = {
    sopsFile = ../../sops/secrets/fword-wireguard.yml;
  };

  sops.secrets.wireguard-psk = {
    sopsFile = ../../sops/secrets/fword-wireguard.yml;
  };

  networking.wg-quick.interfaces.wg0 = {
    address = [ "172.16.0.101/24" ];

    autostart = false;

    listenPort = 51820;

    privateKeyFile = config.sops.secrets.wireguard-private-key.path;

    peers = [
      {
        # vps
        publicKey = "O16pJMqmQP0GxG7h/gDIgY+B4FeYuo/4hlxfXWYSEys=";
        presharedKeyFile = config.sops.secrets.wireguard-psk.path;
        allowedIPs = [ "172.16.0.0/24" "10.14.10.1/24" ];
        endpoint = "vpn.tuer.wtf:51820";
      }
    ];
  };
}
