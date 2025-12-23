#!/usr/bin/env bash
set -e

sudo apt update

xargs -a packages/base.txt sudo apt install -y
xargs -a packages/hyprland.txt sudo apt install -y
xargs -a packages/mint.txt sudo apt install -y

