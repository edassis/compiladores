cmake -B build -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -Wno-dev

cmake --build build -j 6
