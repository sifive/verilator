#!/bin/bash

set -eux

pkg_arch=amd64
pkg_dir=$(realpath ./verilator_${PACKAGE_VERSION}_${pkg_arch})

autoconf
./configure
make
make test
make install DESTDIR=$pkg_dir

mkdir $pkg_dir/DEBIAN
cat << EOF > $pkg_dir/DEBIAN/control
Package: verilator
Version: ${PACKAGE_VERSION}
Architecture: ${pkg_arch}
Maintainer: Richard Xia <rxia@sifive.com>
Depends: perl (>= 5.22.1)
Description: fast free Verilog simulator
EOF

dpkg-deb --build $pkg_dir
