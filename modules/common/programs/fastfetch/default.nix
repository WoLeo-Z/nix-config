{ pkgs, ... }:

{
  user.packages = with pkgs; [ fastfetch ];
}
