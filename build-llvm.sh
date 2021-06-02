. ./setup.sh
    
    if [[ ! -d llvm ]]; then
        git clone https://github.com/flang-compiler/llvm.git
        (cd llvm && git checkout release_70)
    fi
    
    cd llvm
    mkdir -p build && cd build
    cmake $CMAKE_OPTIONS -DCMAKE_C_COMPILER=$GCC_VERSION -DCMAKE_CXX_COMPILER=$CXX_VERSION
    make -j$(nproc)
    make install
