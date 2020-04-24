#!/bin/sh
me=$(basename $0)
my_dir=$(cd "$(dirname "$0")"; pwd)

for file in $(ls -A $my_dir | grep -v $me); do
  ln -fs "$my_dir/$file" $HOME
done
