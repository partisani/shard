{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pkgsCross.i686-embedded.buildPackages.gcc
    fasm
    gnumake
    qemu
    qemu_kvm
    bochs
  ];
}
