# stow
rm -f ~/.zshrc ~/.gitconfig ~/.config/starship.toml
stow git zsh starship lsd alacritty cheat --target=$HOME
