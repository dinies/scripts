#!/bin/bash
set -e

home_path=/home/$USERNAME
cd $home_path/inria_wbc

if [[  $# -eq 0 ]]
then
  echo "param branch name required. Example : $  ./compile_branch_inria_wbc.sh devel"
  echo "branches to choose from are:"
  git pull
  BRANCHES=$(git branch -r)
  echo "$BRANCHES"
  exit 0
fi


branch_name="$1"

git checkout $branch_name
cd build
rm -rf *
cmake  -D CMAKE_PREFIX_PATH=$home_path/install -D CMAKE_INSTALL_PREFIX=$home_path/install -D CMAKE_BUILD_TYPE=Release ..
make -j10
sudo make install
cd $home_path
