{ config, pkgs, inputs, ... }:
{
  programs.niri.enable = true;

  # These packages are required for niri
  environment.systemPackages = with pkgs; [
    fuzzel
    gnome-keyring
    mako
    swaylock
    waybar
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    inputs.xwayland-satellite.packages.${pkgs.system}.xwayland-satellite
  ];

  # TODO: install niri-portals.conf
}
