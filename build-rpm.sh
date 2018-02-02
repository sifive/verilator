#!/bin/bash

set -eux

pkg_arch=x86_64
pkg_distro=centos
pkg_dir=$(realpath ./verilator_${PACKAGE_VERSION}_${pkg_arch}_${pkg_distro})

pkg_version=$(echo ${PACKAGE_VERSION} | cut -d- -f1)
pkg_release=$(echo ${PACKAGE_VERSION} | cut -d- -f2)

autoconf
./configure
make clean
make
make test
make install DESTDIR=$pkg_dir

cat << EOF > verilator.spec
Name: verilator
Version: ${pkg_version}
Release: ${pkg_release}
Requires: perl >= 5.2.11
Summary: Verilog HDL simulator
License: Perl Artistic License and GNU Lesser General Public License

%description
Verilog HDL simulator

%prep

%build

%install
rsync -a ${pkg_dir}/ %buildroot/

%files
%defattr(0644, root,root)
%attr(0755, root,root) /usr/local/bin/verilator*
/usr/local/share/man/man1/verilator*
/usr/local/share/pkgconfig/verilator.pc
/usr/local/share/verilator/*
EOF

rpmbuild -bb verilator.spec
cp /root/rpmbuild/RPMS/${pkg_arch}/verilator-${PACKAGE_VERSION}.${pkg_arch}.rpm ./
