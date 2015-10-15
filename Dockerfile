FROM ubuntu:trusty

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential bison flex curl gcc g++ make texinfo zlib1g-dev g++ unzip curl git

WORKDIR /root
RUN git clone https://github.com/foone/build-djgpp.git
WORKDIR /root/build-djgpp
RUN ./build-djgpp.sh 5.2.0
VOLUME /root/src
WORKDIR /root/src
ENV PATH /usr/local/djgpp/i586-pc-msdosdjgpp/bin/:$PATH
ENV GCC_EXEC_PREFIX /usr/local/djgpp/lib/gcc/

