{ lib, pkgs, ... }:
{
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    
    settings.container_manager = "podman";

    containers = {
      arch = {
        image = "archlinux:latest";
        replace = true;
      };
      
      ubuntu = {
        image = "ubuntu:latest";
        replace = true;
      };
    };
  };
}
