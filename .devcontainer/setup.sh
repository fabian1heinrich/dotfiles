# apt
sudo apt update
sudo apt install zsh stow fzf lsd bat tree fd-find -y
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# install zsh-plugins
zsh install-zsh-plugins.zsh

# stow
rm ~/.zshrc ~/.gitconfig ~/.config/starship.toml
stow git zsh starship lsd alacritty --target=$HOME
