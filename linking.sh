#!/usr/bin/env bash

# Copyright (C) 2020 Heuna Kim <heynaheyna9@gmail.com>

if [[ $# -ne 2 ]]; then
    echo "USAGE: $(basename "$0") USERNAME HOSTNAME" >&2
    exit 1
fi

sed -e "s,USERTOREPLACE,$1,;s,HOSTNAME,$2," ./configuration.nix | sudo sh -c "cat > /etc/nixos/configuration.nix"

NIXPKGSDIR=$HOME/.config/nixpkgs

mkdir -p $NIXPKGSDIR

[[ ! -e $NIXPKGSDIR/home.nix ]] ||  rm "$NIXPKGSDIR/home.nix"
ln -s "$PWD/home.nix" "$NIXPKGSDIR/home.nix"

for FD in configs-to-include external-config; do
    [[ ! -e $NIXPKGSDIR/$FD ]] || rm -r $NIXPKGSDIR/$FD
    ln -s $PWD/$FD $NIXPKGSDIR/$FD
done

CONKYRC=$HOME/.config/conky/conky.conf
[[ ! -e  $CONKYRC ]] | rm $CONKYRC
ln -s $PWD/external-config/conky.conf $CONKYRC
