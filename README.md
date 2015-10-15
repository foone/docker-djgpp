# docker-djgpp
A dockerfile for crosscompiling to DOS using DJGPP

Still under development, and it probably doesn't work yet. Compiling GCC is hard!


# Example build:

docker run -v $(realpath src):/root/src/ foone/djgpp gcc hello.c -o hello.exe
