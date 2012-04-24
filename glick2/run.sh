#!/bin/sh

build_module ()
{
  if test -d $2; then
    cd $2
    svn up
  else
    svn co https://$1/$2 $2
    cd $2
    ./autogen.sh --prefix=/opt/bundle --disable-static --disable-debug
  fi
  make && make install-strip DESTDIR=$PWD/../../install
  cd ..
}

mkdir -p build; cd build

build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk bml
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk gst-buzztard
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk buzztard
build_module buzztard.svn.sourceforge.net/svnroot/buzztard/trunk bsl

build_module buzzmachines.svn.sourceforge.net/svnroot/buzzmachines/trunk buzzmachines

cd ..

rm -rf install/opt/bundle/include
rm -f install/opt/bundle/lib/*.a
rm -rf install/opt/bundle/lib/pkgconfig
rm -rf install/opt/bundle/lib/girrepository
rm -rf install/opt/bundle/share/gir
find install/opt/bundle/ -name "*.la" -delete

rm -f buzztard.bundle
glick-mkbundle -i org.buzztard.buzztard -v 0.6 -e bin/buzztard-edit \
   -E /share/mime-info -E /share/icons -E /share/applications \
   ./install/opt/bundle buzztard.bundle

# glick-runner buzztard.bundle -exec bin/buzztard-edit
