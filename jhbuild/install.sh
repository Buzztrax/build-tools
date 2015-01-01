#!/bin/sh
#
# create an empty directory where you want the software to be installed, enter
# it and run:
# curl https://raw.githubusercontent.com/Buzztrax/build-tools/master/jhbuild/install.sh | sh

fail=0

which >/dev/null jhbuild
if [ $? != 0 ]; then
  echo "E: missing jhbuild tool"
  echo "please install with your distributions package management"
  echo "or build from https://git.gnome.org/browse/jhbuild."
  fail=1
fi

which >/dev/null curl
if [ $? != 0 ]; then
  echo "E: missing curl tool"
  echo "please install with your distributions package management."
  fail=1
fi

if [ $fail == 1 ]; then
  exit
fi

cat >build.sh <<SCRIPT
#!/bin/sh

REPO=https://raw.githubusercontent.com/Buzztrax/build-tools/master/jhbuild
curl --remote-name \$REPO/buzztrax.modules --remote-name \$REPO/buzztrax.jhbuild.rc
sed -i -e "s#~/buzztrax#\$PWD#" buzztrax.jhbuild.rc

jhbuild -f $PWD/buzztrax.jhbuild.rc
if [ \$? != 0 ]; then
  echo "E: build failed"
  exit
fi
echo "I: build finished"
echo "run the application using ./run.sh"
SCRIPT
chmod a+x build.sh

cat >run.sh <<SCRIPT
#!/bin/sh
jhbuild -f $PWD/buzztrax.jhbuild.rc run $PWD/jhbuild/install/bin/buzztrax-edit
SCRIPT
chmod a+x run.sh

./build.sh

