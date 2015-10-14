FROM ubuntu:trusty

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl git texinfo flex bison unzip libgmp-dev libmpc-dev libmpfr-dev

# Based on this page:
# http://nathancoulson.com/proj/i586-pc-msdosdjgpp.php


# Build msdos bintools
run mkdir -p /xc/src/binutils /xc/src/djcrx /xc/src/gcc /xc/src/gcc/build
WORKDIR /xc/src/binutils
RUN curl -s ftp://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2 | tar xj --strip-components 1
WORKDIR /xc/src/binutils/build
RUN ../configure --prefix=/usr --target=i586-pc-msdosdjgpp --with-sysroot=/usr/i586-pc-msdosdjgpp/sysroot && make && make install

# Install DJCRX 204 (205 exists. maybe we should upgrade?)
WORKDIR /xc/src/djcrx
RUN curl ftp://ftp.delorie.com/pub/djgpp/beta/v2/djcrx204.zip -o djcrx.zip && unzip djcrx.zip
RUN install -d -m755 /usr/i586-pc-msdosdjgpp/bin 
RUN install -d -m755 /usr/i586-pc-msdosdjgpp/sysroot/dev/env/DJDIR

RUN cp -a include /usr/i586-pc-msdosdjgpp/sysroot
RUN cp -a lib /usr/i586-pc-msdosdjgpp/sysroot

WORKDIR /xc/src/djcrx/src/stub
RUN gcc -O2 stubify.c -o /usr/i586-pc-msdosdjgpp/bin/stubify
RUN gcc -O2 stubedit.c -o /usr/i586-pc-msdosdjgpp/bin/stubedit


# build msdos GCC
WORKDIR /xc/src/gcc
RUN curl -s ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.1/gcc-4.8.1.tar.bz2 | tar xj --strip-components 1
RUN curl -s http://nathancoulson.com/proj/cross/gcc-4.8.1-djgpp_fixes-1.patch -o gcc-4.8.1-djgpp_fixes-1.patch
RUN patch -Np1 -i gcc-4.8.1-djgpp_fixes-1.patch
WORKDIR /xc/src/gcc/build
RUN install -d -m755 /usr/i586-pc-msdosdjgpp/sysroot/dev/env/DJDIR/include
RUN ../configure --prefix=/usr --target=i586-pc-msdosdjgpp --enable-languages=c --with-sysroot=/usr/i586-pc-msdosdjgpp/sysroot --libexecdir=/usr/lib --disable-static --disable-libssp
RUN make && make install

