#!/bin/sh
me=`basename $0`
for file in `ls -A | grep -v $me`; do
  ln -fs "$PWD/$file" $HOME
done
