#!/bin/bash
nim c -d:debug --gc:arc -d:useMalloc --passC:"-O2" test.nim && valgrind --leak-check=full ./test
nim c -d:debug --gc:arc -d:useMalloc --passC:"-O2" demo.nim && valgrind --leak-check=full ./demo
nim c -d:danger --gc:arc -d:lto --run benchmark.nim
