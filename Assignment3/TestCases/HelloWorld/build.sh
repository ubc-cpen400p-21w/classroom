#!/bin/sh


# Before using this script, please set the LLVM_BUILD_DIR environment variable.
# example: export LLVM_BUILD_DIR=/home/cpen400/llvm-project/build

rm *.bc
$LLVM_BUILD_DIR/bin/clang -O0 -g -emit-llvm -o HelloWorld.bc -c HelloWorld.c
