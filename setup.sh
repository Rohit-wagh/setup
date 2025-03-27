#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

setup_nvim() {
  echo "Installing Node.js..."
  sudo apt install -y nodejs npm

  echo "Setting up Neovim..."
  mkdir -p "$HOME/personal/nvim"
  git clone -b v0.10.4 https://github.com/neovim/neovim.git "$HOME/personal/nvim"

  sudo apt install -y cmake gettext lua5.1 liblua5.1-0-dev

  cd "$HOME/personal/nvim" || exit 1
  cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
  make -j$(nproc)
  sudo make install

  echo "Cloning Neovim configuration..."
  git clone https://github.com/Rohit-wagh/nvim ~/.config/nvim
}

setup_lazygit() {
  echo "Installing LazyGit..."
  mkdir -p "$HOME/personal/lazygit"
  cd "$HOME/personal/lazygit" || exit 1

  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
}

setup_tmux() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "Setting up Tmux configuration..."
  mkdir -p "$HOME/personal/tmux"
  git clone https://github.com/Rohit-wagh/tmux.git "$HOME/personal/tmux"

  cd "$HOME/personal/tmux" || exit 1
  ln -sf "$HOME/personal/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

install_go() {
  echo "Installing Go..."
  GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1) 

  curl -LO "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"
  rm "${GO_VERSION}.linux-amd64.tar.gz"

  # Add Go to PATH
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.zshrc"
  source "$HOME/.bashrc"

  echo "Go installation completed!"
}

install_k9s() {
  echo "Installing k9s..."
  git clone -b v0.40.10 https://github.com/derailed/k9s.git "$HOME/personal/k9s"
  cd "$HOME/personal/k9s" || exit 1
  make build
  sudo mv ./execs/k9s /usr/local/bin/
  sudo apt install kubectx # Installing kubectx and kubens
}


# Check for argument and execute corresponding function
case "$1" in
  nvim)
    setup_nvim
    ;;
  lazygit)
    setup_lazygit
    ;;
  go)
    install_go
    ;;
  tmux)
    setup_tmux
    ;;
  k9s)
    install_k9s
    ;;
  all)
    setup_nvim
    setup_lazygit
    setup_tmux
    install_go
    install_k9s
    ;;
  *)
    echo "Usage: $0 {nvim|lazygit|tmux}"
    exit 1
    ;;
esac


