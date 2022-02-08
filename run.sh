cmake -B build -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -Wno-dev

make -C build -j3