#!/bin/bash
cd $HOME
xstring=""
for i in `grep path .personal/configs/.gitmodules  | sed 's/\s*path = //'`; do
    xstring="${xstring} --exclude=.personal/configs/$i"
done
xstring="${xstring} --exclude=.git"

file="personal_`date +'%Y_%m_%d'`.tbz2"
tar ${xstring} -cjvhf $file .personal/
gpg -c --cipher-algo AES256 $file && rm $file
