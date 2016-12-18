#!/bin/bash
PERSONAL=".personal"

cwd=`pwd`
cd $HOME

xstring=""
for i in `grep path $PERSONAL/configs/.gitmodules  | sed 's/\s*path = //'`; do
    xstring="${xstring} --exclude=$PERSONAL/configs/$i"
done
xstring="${xstring} --exclude=.git"
xstring="${xstring} --exclude=$PERSONAL/configs/.vim/bundle"
xstring="${xstring} --exclude=$PERSONAL/configs/.emacs.d/auto-save-list"

echo -n "Have you generated .kdb version? [yes/no] "
read kdb
if [ "$kdb" != "yes" ]; then
    exit 1
fi

# Clean up okular
cd $PERSONAL/okular_docdata
./clean.sh
cd -

file="personal_`date +'%Y_%m_%d'`.tbz2"
tar ${xstring} -cjvhf $file $PERSONAL
gpg -c --cipher-algo AES256 $file && rm $file

cd $cwd
