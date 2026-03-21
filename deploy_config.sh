TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
curl -fsSL https://codeload.github.com/Kunimaru/personal-config/tar.gz/refs/heads/main -o "$TMP_DIR/personal-config.tar.gz"
tar -xzf "$TMP_DIR/personal-config.tar.gz" -C "$TMP_DIR"
REMOTE_CONFIG_DIR="$TMP_DIR/personal-config-main/config"
if [ ! -d "$REMOTE_CONFIG_DIR" ]; then
    echo "Remote config directory not found: $REMOTE_CONFIG_DIR" >&2
    exit 1
fi
mkdir -p "$HOME/.config"
find "$REMOTE_CONFIG_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec cp -a {} "$HOME/" \;
