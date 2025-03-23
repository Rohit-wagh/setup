OPTIONS=$1

sudo apt update && sudo apt upgrade -y 

neovim () {
  git clone -b v0.10.4 https://github.com/neovim/neovim.git $HOME/personal/nvim
  sudo apt install cmake gettext lua5.1 liblua5.1-0-dev

  cd $HOME/personal/nvim
  cd CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
}

lazygit (){
  cd $HOME/personal/lazygit
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
}

case OPTIONS in
  "all")
    neovim
    lazygit
    ;;
  "neovim")
    neovim
    ;;
  "lazygit")
    lazygit
    ;;
  *)
    echo -n "Invalid"
    ;;
esac
