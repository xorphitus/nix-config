#!/usr/bin/env bash

set -euo pipefail

setupLinux() {
    echo "Setting up VOICEVOX container..."
    docker pull voicevox/voicevox_engine:nvidia-latest

    # Although a NixOS package is available, it may not work perfectly because the search feature may show "Something went wrong."
    echo "Setting up Spotify because the NixOS repository package may not work..."
    flatpak install -y com.spotify.Client

    echo "Updating flatpak packages..."
    flatpak update -y

    # https://github.com/openai/codex/issues/15340
    echo "Configuring workaround for Codex..."
    sudo ln -sf /run/current-system/sw/bin/bwrap /usr/bin/bwrap

    echo "Linux setup complete!"
}

setupDarwin() {
    echo "Setting up Darwin aliases to enable Spotlight search..."

    local destination="/Applications/MyNixApps"

    if [ -d "$destination" ]; then
        rm -rf "$destination"
    fi

    mkdir -p "$destination"

    find -L ~/Applications/Home\ Manager\ Apps -name '*.app' -type d | grep -v '.app/' | while read -r app; do
        src=$(readlink -f "$app")
        app_name=$(basename "$app")

        if [ "$app_name" = "azooKeyMac.app" ]; then
            echo "azooKey installation: root permission is required"
            dest="/Library/Input Methods/$app_name"
            sudo ditto "$src" "$dest"
        else
            mkalias "$src" "$destination/$app_name"
        fi
    done

    echo "Darwin specific setup complete!"
}

echo "Setting up Fish environment..."
fish -c "setup-fish-env"

echo "Installing Emacs resources..."
emacs --batch \
    --eval "(fset 'yes-or-no-p #'always)" \
    --eval "(fset 'y-or-n-p #'always)" \
    -l ~/.emacs.d/init.el \
    --eval "(my-install)"

echo "Installing mise tools..."
mise install
mise upgrade

echo "Installing global npm packages..."
mise exec -- npm install -g @anthropic-ai/sandbox-runtime

# The Nix package version is too old
echo "Installing Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

case "$(uname -s)" in
    Linux*)
        setupLinux
        ;;
    Darwin*)
        setupDarwin
        ;;
esac

echo "Setup complete!"
