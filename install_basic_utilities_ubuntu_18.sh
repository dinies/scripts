#!/bin/bash
set -e

#installing utilities
sudo apt update && sudo apt install -y vim tmux gdb silversearcher-ag tree clang-format

# Cmake latest version 
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
gpg --dearmor - | \
sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
sudo apt update && \
sudo apt install -y \
  cmake \
  cmake-curses-gui

# Upgrade gcc compiler to gcc-10 
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
sudo apt update && \
sudo apt install -y gcc-10 g++-10 && \
sudo update-alternatives \
  --install /usr/bin/gcc gcc /usr/bin/gcc-10 20 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-10


# clang_format
clang-format -style=google -dump-config > ~/.clang-format
#cmd to apply the formatting:  find . -regex '.*\.\(cpp\|hpp\|cu\|c\|h\)' -exec clang-format -style=google -i {} \;


#update robot-dart
cd ~/robot_dart
git pull
./waf configure --prefix=~/install --shared
./waf
./waf install

#update inria_wbc
cd ~/inria_wbc
git remote set-url origin git@github.com:resibots/inria_wbc.git
git pull
cd ~/inria_wbc/build
rm -rf *
cmake  -D CMAKE_PREFIX_PATH=~/install -D CMAKE_BUILD_TYPE=Release  -D CMAKE_INSTALL_PREFIX=~/install ..
make -j$((`nproc`-2))
sudo make install
