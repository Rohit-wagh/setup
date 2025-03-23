git clone -b v0.10.4 https://github.com/neovim/neovim.git $HOME/personal/nvim
sudo apt install cmake gettext lua5.1 liblua5.1-0-dev

cd $HOME/personal/nvim
cd CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
