. ./setup.sh

if [[ ! -d openmp ]]; then
    git clone https://github.com/llvm-mirror/openmp.git
    (cd openmp && git checkout release_70)
fi

cd openmp
mkdir -p build && cd build
cmake $CMAKE_OPTIONS ..
make -j$(nproc)
make install
