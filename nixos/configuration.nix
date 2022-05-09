{ config, pkgs, lib, ... }: {
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;

  # if you have a Raspberry Pi 2 or 3, pick this:
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # A bunch of boot parameters needed for optimal runtime on RPi 3b+
  boot = {
    kernelParams = [ "cma=256M" ];
    supportedFilesystems = [ "ntfs" ];
    loader.raspberryPi = {
      enable = true;
      version = 3;
      uboot.enable = true;
      firmwareConfig = ''
        gpu_mem=256
      '';
    };
  };
  environment.systemPackages = with pkgs; [ libraspberrypi vim ];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.cleanTmpDir = true;

  # Configure basic SSH access
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  networking = {
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "192.168.1.1";
    hostName = "raspi3b";
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "192.168.1.2";
        prefixLength = 24;
      }];
    };
  };
}
