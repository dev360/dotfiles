
# Pull all submodules first
git pull && git submodule init && git submodule update && git submodule status

cp -rf .vim ~/.vim
cp -f .vimrc ~/.vimrc

if [ ! -f ~/.vimrc.local ];
then
    cp .vimrc.local ~/.vimrc.local
else
    read -p "Overwrite ~/.vimrc.local? y/n " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cp -f .vimrc.local ~/.vimrc.local
    fi
fi


echo "Vim settings copied successfully"
