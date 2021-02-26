#!/bin/bash
set -e

if [[  $# -eq 0 ]]
  echo "param branch name required. Example : $  ./compile_branch_inria_wbc.sh devel"
  exit 1
fi

branch_name="$1"
home_path=/home/$USERNAME

cd $home_path/inria_wbc
git checkout $branch_name
cd build
rm -rf *
cmake  -D CMAKE_PREFIX_PATH=$home_path/install -D CMAKE_INSTALL_PREFIX=$home_path/install -D CMAKE_BUILD_TYPE=Release ..
make -j10
sudo make install
cd $home_path
