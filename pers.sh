#!/bin/bash
cd $HOME
xstring=""
for i in `grep path .personal/configs/.gitmodules  | sed 's/\s*path = //'`; do
    xstring="${xstring} --exclude=.personal/configs/$i"
done
xstring="${xstring} --exclude=.git"

echo -n "Have you generated .kdb version? [yes/no] "
read kdb

if [ "$kdb" != "yes" ]; then
    exit 1
fi

file="personal_`date +'%Y_%m_%d'`.tbz2"
tar ${xstring} -cjvhf $file .personal/
gpg -c --cipher-algo AES256 $file && rm $file
