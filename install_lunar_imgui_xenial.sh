#!/bin/bash
set -e

#installing utilities
sudo apt update
sudo apt install -y vim tmux gdb silversearcher-ag tree

cd ~
git clone https://github.com/dinies/dotfiles.git
cd dotfiles/scripts
./set_up.sh


echo "alias cm='catkin_make'" >> ~/.bashrc
echo "wssource() {" >> ~/.bashrc
echo "  source \$1/devel/setup.bash" >> ~/.bashrc
echo "}" >> ~/.bashrc

git config --global user.name "dinies"
git config --global user.email edoardo.ghini@live.it


#installing ROS lunar 
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get install -y ros-lunar-desktop-full
echo "source /opt/ros/lunar/setup.bash" >> ~/.bashrc
source /opt/ros/lunar/setup.bash
sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo rosdep init
rosdep update
mkdir -p ~/catkin_ws/src

#installing opencv
cd ~
sudo apt-get install -y gcc g++
sudo apt-get install -y python-dev python-numpy
sudo apt-get install -y python3-dev python3-numpy
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libgtk-3-dev
sudo apt-get install -y libpng-dev
sudo apt-get install -y libjpeg-dev
sudo apt-get install -y libopenexr-dev
git clone https://github.com/opencv/opencv.git
cd ~/opencv/
git fetch
git fetch --tags
git checkout 3.1.0
mkdir build && cd build
cmake -DWITH_CUDA:BOOL="0" ..
make -j
sudo make install


#installing nlohmann_json.
cd ~
git clone  https://github.com/nlohmann/json.git
cd json/
mkdir build && cd build
cmake ..
make -j
sudo make install


#installing glad glfw
cd ~
git clone https://github.com/dinies/glad.git
git clone https://github.com/glfw/glfw.git
cd glfw/
mkdir build && cd build/
cmake ..
make -j4
sudo make install

cd ~/catkin_ws/src/
git clone https://gitlab.inria.fr/telemovtop/teletop_gui.git
