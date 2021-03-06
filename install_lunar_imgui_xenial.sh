#!/bin/bash

#make sure that you have set up the ssh keys for github and gitlab (Readme)

set -e
git config --global user.name "dinies"
git config --global user.email edoardo.ghini@live.it
git config --global push.default simple


#installing ROS lunar 
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata
sudo apt-get install -y ros-lunar-desktop-full
echo "source /opt/ros/lunar/setup.bash" >> ~/.bashrc
source /opt/ros/lunar/setup.bash
sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo rosdep init
rosdep update


mkdir -p ~/catkin_ws/src

#cloning repositories
cd ~/catkin_ws/src/
git clone git@gitlab.inria.fr:telemovtop/teletop_gui.git
git clone git@gitlab.inria.fr:telemovtop/robotdart_module.git
git clone git@gitlab.inria.fr:telemovtop/teletop_controller.git
cd ~

git clone git@gitlab.inria.fr:telemovtop/proto_urdf.git
git clone git@gitlab.inria.fr:telemovtop/rooftop-telesim.git
git clone git@github.com:dinies/dotfiles.git
git clone git@github.com:opencv/opencv.git
git clone git@github.com:nlohmann/json.git
git clone git@github.com:dinies/glad.git
git clone git@github.com:glfw/glfw.git


#installing utilities
sudo apt install -y vim tmux gdb silversearcher-ag tree cmake-curses-gui

#setting-up custom dotfiles
cd ~/dotfiles/scripts
./set_up.sh
echo "alias cm='catkin_make'" >> ~/.bashrc
echo "wssource() {" >> ~/.bashrc
echo "  source \$1/devel/setup.bash" >> ~/.bashrc
echo "}" >> ~/.bashrc

#installing opencv
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

cd ~/opencv/
git fetch
git fetch --tags
git checkout 3.1.0
mkdir build && cd build
cmake -DWITH_CUDA:BOOL="0" ..
make -j && sudo make install

#installing nlohmann_json.
cd ~/json/
mkdir build && cd build
cmake ..
make -j && sudo make install


#installing glad glfw
cd ~/glfw/
mkdir build && cd build/
cmake ..
make -j && sudo make install

#clean-up
rm -rf ~/opencv
rm -rf ~/json
rm -rf ~/glfw

#add-rooftop-urdf and prototype urdf to-robot-dart
mv ~/rooftop-telesim/robots/rooftop ~/robot_dart/robots
mv ~/proto_urdf/prototype ~/robot_dart/robots
cd ~/robot_dart
./waf
./waf install



#recompile-inria_wbc-without-example-
cd ~/inria_wbc
git pull
git checkout mydev_refactorinit
git pull origin mydev_refactorinit
cd ~/inria_wbc/build
rm -rf *
cmake -DCMAKE_INSTALL_PREFIX=/home/user/install -DCOMPILE_ROBOT_DART_EXAMPLE=OFF ..
make -j
sudo make install

