#!/bin/bash

nim c -d:danger --gc:arc -d:lto benchmark.nim
./benchmarkOld > benchmarkOld.output &
./benchmark > benchmarkNew.output