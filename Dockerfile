FROM ubuntu:trusty

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl git texinfo flex bison
RUN mkdir /xc && mkdir /xc/src && mkdir /xc/src/gcc 
WORKDIR /xc/src/gcc
RUN curl -s ftp://sourceware.org/pub/binutils/snapshots/binutils-2.24.51.tar.bz2 | tar xj --strip-components 1
RUN curl -s http://www.netgull.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.bz2 | tar xj --strip-components 1
RUN mkdir gmp && curl -s ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2 | tar xj -C gmp --strip-components 1
RUN mkdir mpfr && curl -s ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2 | tar xj -C mpfr --strip-components 1
RUN mkdir mpc && curl -s ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz | tar xz -C mpc --strip-components 1

RUN ./configure --enable-languages=c,c++ --target=i586-pc-msdosdjgpp --prefix=/xc && make