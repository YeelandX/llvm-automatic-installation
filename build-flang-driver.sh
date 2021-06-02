    . ./setup.sh
 
    if [[ ! -d flang-driver ]]; then
        git clone https://github.com/flang-compiler/flang-driver.git
        (cd flang-driver && git checkout release_70)
    fi
    
    cd flang-driver
    mkdir -p build && cd build
    cmake $CMAKE_OPTIONS -DCMAKE_C_COMPILER=$GCC_VERSION -DCMAKE_CXX_COMPILER=$CXX_VERSION ..
    make -j$(nproc)
    make install
