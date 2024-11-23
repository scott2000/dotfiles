{ config, pkgs, ... }:
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
    xwayland-satellite
    # TODO: niriswitcher?
  ];

  # TODO: install niri-portals.conf
}
