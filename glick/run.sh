#!/bin/sh
# run with: glick-shell ./install/

#jhbuild -f ./buzztard.jhbuildrc -m ~/projects/buzztard/build-tools/jhbuild/buzztard.modules

build_module ()
{
  if test -d $2; then
    cd $2
    svn up
  else
    svn co https://$1/$2 $2
    cd $2
    ./autogen.sh --prefix=/proc/self/fd/1023 --disable-static
  fi
  make && make install
  cd ..
}

mkdir -p build; cd build

build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk bml
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk gst-buzztard
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk buzztard
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk bsl

build_module buzzmachines.svn.sourceforge.net/svnroot/buzzmachines/trunk buzzmachines

cd ..

cp start install/
sudo glick-mkext2 image.ext2 install
mkglick buzztard.glick image.ext2 --icon ./install/share/icons/gnome/48x48/apps/buzztard.png --desktop-file ./install/share/applications/buzztard-edit.desktop

