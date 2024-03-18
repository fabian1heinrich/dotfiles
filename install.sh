sudo apt update
sudo apt install zsh stow fzf -y

# install zsh-plugins
zsh install-zsh-plugins.zsh

# stow
stow --adopt -t ~ */ 
git restore .

source ~/.zshrc