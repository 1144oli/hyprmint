#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root. It will use sudo when needed."
   exit 1
fi

log_info "Starting Hyprland Mint installation..."

log_info "Updating system packages..."
sudo apt update
sudo apt upgrade -y

log_info "Installing base packages..."
xargs -a packages/base.txt sudo apt install -y

log_info "Installing Mint packages..."
xargs -a packages/mint.txt sudo apt install -y

log_info "Installing Hyprland dependencies..."
xargs -a packages/hyprland.txt sudo apt install -y

log_info "Building Hyprland from source..."
HYPRLAND_VERSION="v0.45.2" 

BUILD_DIR="/tmp/hyprland-build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clone Hyprland
if [ ! -d "Hyprland" ]; then
    git clone --recursive https://github.com/hyprwm/Hyprland.git
fi

cd Hyprland
git checkout "$HYPRLAND_VERSION"
git submodule update --init --recursive

make all

sudo make install

log_info "Hyprland installed successfully!"

log_info "Deploying configuration files..."
mkdir -p ~/.config/hypr
cp -r configs/hypr/* ~/.config/hypr/

log_info "Setting up Wayland ecosystem..."
# do hyprland stuff here.

log_info "Creating Hyprland session entry..."
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

log_info "Installation complete! You can now select Hyprland from your login manager."
log_warn "Remember to log out and select Hyprland from the session menu."
```

