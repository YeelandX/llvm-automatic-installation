#!/bin/sh

# +------------------------------------------------------------+
# ｜Attention!Install environmental requirement!               |
# ｜                                                           ｜
# ｜Targets to build should be one of: X86 PowerPC AArch64     ｜
# ｜cmake >= 3.13.4                                            ｜
# ｜gcc >= 5.1.0                                               ｜
# ｜python >= 3.6                                              ｜
# ｜zlib >=1.2.3.4                                             ｜
# ｜GNU make >= 3.7.9                                          ｜
# +------------------------------------------------------------+

#dir|-(安装目录)
#   |-llvm_install.sh(本脚本)
#   |-llvm_installation_pkg(安装包)
#   |-netcdf_install(netcdf安装目录)
#   |-llvm_install(llvm安装目录)
#   |-env.sh(设置环境变量:source env.sh)

# Environment manual check
while true; do
    read -p "Please check your software version and type 'Y': " check
    case $check in
    [Yy]) break ;;
    esac
done

# Environment setup
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


# Get llvm_installation_pkg
cd $INSTALL_PATH
if [[ ! -d llvm_installation_pkg ]]; then
    git clone --recursive  git://github.com/YeelandX/llvm_installation_pkg.git || exit
fi

# Install llvm  
cd $INSTALL_PKG/llvm || exit
mkdir -p build && cd build
cmake $CMAKE_OPTIONS -DCMAKE_C_COMPILER=$GCC_VERSION -DCMAKE_CXX_COMPILER=$CXX_VERSION .. || exit
make -j$NPROC -l1 && make install || exit

# Install flang-driver
cd $INSTALL_PKG/flang-driver || exit
mkdir -p build && cd build
cmake $CMAKE_OPTIONS -DCMAKE_C_COMPILER=$GCC_VERSION -DCMAKE_CXX_COMPILER=$CXX_VERSION .. || exit
make -j$NPROC -l1 && make install || exit

# Install openmp
cd $INSTALL_PKG/openmp || exit
mkdir -p build && cd build
cmake $CMAKE_OPTIONS .. || exit
make -j$NPROC -l1 && make install || exit

#Install flang
cd $INSTALL_PKG/flang/runtime/libpgmath || exit
mkdir -p build && cd build
cmake $CMAKE_OPTIONS .. || exit
make -j$NPROC -l1 && make install || exit

cd $INSTALL_PKG/flang || exit
mkdir -p build && cd build
cmake $CMAKE_OPTIONS .. || exit
make -j$NPROC -l1 && make install || exit

#Environment configuration for llvm
export PATH=$LLVM_INSTALL_PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$LLVM_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH
export PATH=$LLVM_INSTALL_PREFIX/include:$PATH

#Install netcdf
export CC=clang
export CXX=clang
export FC=flang
export F90=flang
export F77=flang
export CPP="clang -E"
export CXXCPP="clang -E"

#Install zlib
cd $INSTALL_PKG
tar -zxvf zlib-1.2.11.tar.gz
cd zlib-1.2.11/ || exit
./configure --prefix=$NETCDF_INSTALL_PREFIX || exit
make -j$NPROC && make check 
make install || exit

#Install hdf5
cd $INSTALL_PKG
tar -zxvf hdf5-1.8.20.tar.gz
cd hdf5-1.8.20/ || exit
./configure --prefix=$NETCDF_INSTALL_PREFIX --with-zlib=$NETCDF_INSTALL_PREFIX --enable-fortran --enable-shared=no --enable-static-exec || exit
make -j$NPROC && make check
make install || exit

#Install netcdf-c
cd $INSTALL_PKG
tar -zxvf netcdf-c-4.4.1.tar.gz
cd netcdf-c-4.4.1/ || exit
CPPFLAGS=-I$NETCDF_INSTALL_PREFIX/include LDFLAGS=-L$NETCDF_INSTALL_PREFIX/lib ./configure --prefix=$NETCDF_INSTALL_PREFIX --disable-dap --enable-shared=no --disable-netcdf4
make -j$NPROC && make check
make install || exit

#Install netcdf-fortran
cd $INSTALL_PKG
tar -zxvf netcdf-fortran-4.4.1.tar.gz
cd netcdf-fortran-4.4.1/ || exit
CPPFLAGS=-I$NETCDF_INSTALL_PREFIX/include LDFLAGS=-L$NETCDF_INSTALL_PREFIX/lib LD_LIBRARY_PATH=$NETCDF_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" ./configure --prefix=$NETCDF_INSTALL_PREFIX --disable-dap --enable-shared=no --disable-netcdf4
make -j$NPROC && make check
make install || exit

echo ":D LLVM Install Successfully!"
echo "请设置环境变量："
echo "LLVM_PATH="$LLVM_INSTALL_PREFIX
echo "LLVMNETCDF_PATH="$NETCDF_INSTALL_PREFIX