# Add user to sudoers
# su root -c "/sbin/adduser $USER sudo && pkill -u $USER"

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Deploy personal configuration files
./deploy_config.sh

# Add "contrib" and "non-free" to /etc/apt/sources.list
sudo vi -N /etc/apt/sources.list

# Install aptitude packages
sudo apt update
sudo apt install -y curl docker fonts-liberation git gnome-shell-extension-dashtodock gnome-shell-extension-gpaste ibus-mozc pulseaudio ufw xsel zsh

# Set zsh as default
sudo chsh -s /bin/zsh $USER

# Setup Git
git config --global push.default current

# Generate SSH for Github
ssh-keygen -t ed25519

echo '# Install these packages manually.'

# Install Alacritty
echo 'Alacritty: https://www.google.com/search?q=alacritty'
firefox-esr --new-tab 'https://www.google.com/search?q=alacritty'

# Install Zed
echo 'Zed: https://www.google.com/search?q=zed'
firefox-esr --new-tab 'https://www.google.com/search?q=zed'

# Install gTile
echo 'gTile: https://www.google.com/search?q=gtile'
firefox-esr --new-tab 'https://www.google.com/search?q=gtile'

# Install Bedtime Mode
echo 'Bedtime Mode: https://www.google.com/search?q=gnome+bedtime+mode'
firefox-esr --new-tab 'https://www.google.com/search?q=gnome+bedtime+mode'

# Install Google Chrome
echo 'Google Chrome: https://www.google.com/search?q=google+chrome'
firefox-esr --new-tab 'https://www.google.com/search?q=google+chrome'

read -p 'Press enter to reboot...' TMP
sudo reboot

# Setup input method
# im-config
# ibus-setup
