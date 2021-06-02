if [[ ! -d llvm_install ]]; then
    mkdir llvm_install
fi
if [[ ! -d netcdf_install ]]; then
    mkdir netcdf_install
fi
INSTALL_PATH=$(pwd)
INSTALL_PKG=$INSTALL_PATH/llvm_installation_pkg
LLVM_INSTALL_PREFIX=$INSTALL_PATH/llvm_install
NETCDF_INSTALL_PREFIX=$INSTALL_PATH/netcdf_install
GCC_VERSION=$(which gcc)
CXX_VERSION=$(which g++)

#***Manual Setting***#
ARCH=X86
NPROC=4
#********************#

CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_PREFIX \
    -DLLVM_CONFIG=$LLVM_INSTALL_PREFIX/bin/llvm-config \
    -DCMAKE_CXX_COMPILER=$LLVM_INSTALL_PREFIX/bin/clang++ \
    -DCMAKE_C_COMPILER=$LLVM_INSTALL_PREFIX/bin/clang \
    -DCMAKE_Fortran_COMPILER=$LLVM_INSTALL_PREFIX/bin/flang \
    -DLLVM_TARGETS_TO_BUILD=$ARCH \
    -DCMAKE_BUILD_TYPE=release"
#***Other optional CMAKE_OPTIONS***#
#-DCMAKE_C_FLAGS=-L$HOME/toolchains/lib64
#-DCMAKE_CXX_FLAGS=-L$HOME/toolchains/lib64
#-DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,$HOME/toolchains/lib64 -L$HOME/toolchains/lib64" 
#-DGCC_INSTALL_PREFIX=$HOME/toolchains ..
#**********************************#