#!/bin/bash
set -e

mkdir -p ~/catkin_ws/src
#cloning repositories
cd ~/catkin_ws/src/
git clone git@gitlab.inria.fr:telemovtop/robotdart_module.git
git clone git@gitlab.inria.fr:telemovtop/teletop_controller.git
git clone git@gitlab.inria.fr:telemovtop/teletop_msgs.git
cd ~
git clone git@gitlab.inria.fr:telemovtop/rooftop-telesim.git
git clone git@github.com:dinies/dotfiles.git
git clone git@github.com:opencv/opencv.git

#installing utilities
sudo apt update && sudo apt install -y vim tmux gdb silversearcher-ag tree 

#setting-up custom dotfiles
cd ~/dotfiles/scripts
echo "alias cm='catkin_make'" >> ~/.bashrc
echo "alias cmtb='catkin_make tests'" >> ~/.bashrc
echo "alias cmt='catkin_make test'" >> ~/.bashrc
echo "wssource() {" >> ~/.bashrc
echo "  source \$1/devel/setup.bash" >> ~/.bashrc
echo "}" >> ~/.bashrc

# Cmake latest version 
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
gpg --dearmor - | \
sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
sudo apt update && \
sudo apt install -y \
  cmake \
  cmake-curses-gui



#installing ROS 
sudo bash -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" \
  > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \
  --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654  && \
sudo apt-get update && \
sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata && \
sudo apt-get install -y ros-melodic-desktop-full && \

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 

source /opt/ros/melodic/setup.bash 

sudo apt install -y \
  python-rosdep \
  python-rosinstall \
  python-rosinstall-generator \
  python-wstool \
  build-essential
sudo rosdep init
rosdep update

# installing opencv 
mkdir -p ~/opencv/build 
cd ~/opencv/build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local .. 
make -j$((`nproc`-2))
sudo make install


#clean-up
rm -rf ~/opencv

#update and add-rooftop-urdf-and-prototype-to-robot-dart
cd ~/robot_dart
git pull
cp -R ~/rooftop-telesim/robots/rooftop ~/robot_dart/robots
cp -R ~/rooftop-telesim/robots/prototype ~/robot_dart/robots
./waf
./waf install

#update inria_wbc
cd ~/inria_wbc
git remote set-url origin git@github.com:resibots/inria_wbc.git
git pull
git checkout no_float_base_dev #soon this branch will be merged into devel
cd ~/inria_wbc/build
rm -rf *
cmake  -D CMAKE_PREFIX_PATH=~/install -D CMAKE_BUILD_TYPE=Release  -D CMAKE_INSTALL_PREFIX=~/install ..
make -j$((`nproc`-2))
sudo make install


