# 大规模科学计算程序性能建模-LLVM安装手册

## 安装环境要求

| 软件 | 版本 |
| --- | --- |
| cmake | >= 3.13.4 |
| gcc |	>= 5.1.0 |
| python | >=3.6 |
| zlib | >=1.2.3.4 |
| GNU Make | >=3.7.9 |

Targets to build should be one of: X86/PowerPC/AArch64

安装耗时挺久的，可以使用`nohup`挂起安装进程。

--- 

## 使用脚本自动安装
（选择手动安装可跳过这部分）

### 1. 选择安装目录
这里我们将安装在/yourpath/llvm目录下

    mkdir llvm && cd llvm

### 2. 把[安装脚本](https://github.com/YeelandX/llvm-automatic-installation/blob/main/llvm_auto_install.sh)拉到该目录下
:)咋拉都行


### 3. 修改脚本中的变量
平台架构 `ARCH`

- default:X86

make -j `NPROC`

- default:4
- suggest:$(nproc)


cmake参数 `cmake_options`
- 可参考[原文档](https://llvm.org/docs/CMake.html)
- 
- **脚本默认设置的cmake参数**
- `CMAKE_INSTALL_PREFIX`:安装路径，不指定则`/usr/local`，脚本中设置为`/yourpath/llvm/llvm_install`
- `LLVM_CONFIG`:llvm-config路径
- `CMAKE_CXX_COMPILER`:指定g++路径
- `CMAKE_C_COMPILER`:指定gcc路径
- `CMAKE_Fortran_COMPILER`:指定fortran编译器
- `LLVM_TARGETS_TO_BUILD`:目标平台的架构,脚本中设置为`x86`
- `CMAKE_BUILD_TYPE`:生成类型，默认是`debug`，脚本中设置为`release`
- 
- **使用非系统gcc/g++时要加上以下选项**
- `CMAKE_C_FLAGS`:c的库路径
- `CMAKE_CXX_FLAGS`:c++的库路径
- `CMAKE_CXX_LINK_FLAGS`:c++动态库路径
- `GCC_INSTALL_PREFIX`:gcc安装前缀


### 4. 运行
    sh llvm_auto_install

后台运行
    
    #后台运行且不杀死该进程
    nohup sh llvm_auto_install &
    #查看运行日志
    tail -f nohop.out



### 5. 设置环境变量
设置安装成功后脚本输出的环境变量。

预期输出是这样：
```
:D LLVM Install Successfully!
请设置环境变量：
LLVM_PATH=/yourpath/llvm/llvm_install
LLVMNETCDF_PATH=/yourpath/llvm/netcdf_install
```

测试一下:

    clang -v
    nc-config



### 6. End
本脚本没有容错哦

要是没成功那你就

看下面的步骤一个个装吧:D

---


## 手动安装
（十分建议手动安装，有点麻烦但成功率较高）

1. 先检查一下环境的软件版本号！
2. 选择安装目录

这里我们将安装在/yourpath/llvm目录下

    mkdir llvm && cd llvm

3. 编译选项和路径

编写一个setup.sh来存储编译选项。

我们指定了一个自定义安装位置，并且通常希望使用clang为X86进行构建。-DCMAKE_INSTALL_PREFIX即为安装位置。
setup.sh内容如下:

    if [[ ! -d llvm_install ]]; then
        mkdir llvm_install
    fi
    if [[ ! -d netcdf_install ]]; then
        mkdir netcdf_install
    fi
    INSTALL_PATH=$(pwd)
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

4. 下载安装llvm

编写一个build-llvm.sh来安装llvm。

先从GitHub上获取release70的llvm，然后在build目录下进行编译安装。
这里我们使用gcc和g++作为c和c++的编译器，其位置默认在/usr/bin。你需要根据自己的gcc和g++位置来指定他们。

`build-llvm.sh`内容如下：
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

运行`build-llvm.sh`:

    ./build-llvm.sh

5. 下载安装clang

编写`build-flang-driver.sh`来进行安装clang。

此步骤安装了clang编译器，安装完成后，我们可以在`llvm_install/bin`目录下看到clang、clang++。安装的clang为7.1.0版本。

`build-flang-driver.sh`内容如下：
    
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


运行`build-flang-driver.sh`:

    ./build-flang-driver.sh

6. 下载安装openemp

编写`build-openmp.sh`来安装openmp。

此步骤开始，我们使用clang、clang++来编译。

`build-openmp.sh`内容如下：

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

运行`build-openmp.sh`:

    ./build-openmp.sh

7. 下载安装flang

编写`build-flang.sh`来安装flang

`build-flang.sh`内容如下：

    . ./setup.sh
    
    if [[ ! -d flang ]]; then
        git clone https://github.com/flang-compiler/flang.git
    fi
    
    cd flang/runtime/libpgmath
    mkdir -p build && cd build
    cmake $CMAKE_OPTIONS ..
    make -j$(nproc)
    make install
    
    cd ../../
    mkdir -p build && cd build
    cmake $CMAKE_OPTIONS ..
    make -j$(nproc)
    make install

运行`build-flang.sh`:

    ./build-flang.sh


8. 把llvm路径添加至环境变量中

在终端输入下列命令

    export PATH=$LLVM_INSTALL_PREFIX/bin:$PATH
    export LD_LIBRARY_PATH=$LLVM_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH
    export PATH=$LLVM_INSTALL_PREFIX/include:$PATH
    

9. netcdf下载安装

在终端输入下列命令

    export CC=clang
    export CXX=clang
    export FC=flang
    export F90=flang
    export F77=flang
    export CPP="clang -E"
    export CXXCPP="clang -E"


下载netcdf软件包

下载链接：https://pan.baidu.com/s/1N1WyDFaqRqLlwUKfGunKiQ 提取码：tddh
    
    export NETCDF_INSTALL_PKG=安装包路径



编写`build-netcdf.sh`来安装netcdf。

`build-netcdf.sh`内容如下：

    . ./setup.sh

    #Install zlib
    cd $NETCDF_INSTALL_PKG
    tar -zxvf zlib-1.2.11.tar.gz
    cd zlib-1.2.11/ 
    ./configure --prefix=$NETCDF_INSTALL_PREFIX 
    make -j$NPROC && make check && make install 

    #Install hdf5
    cd $NETCDF_INSTALL_PKG
    tar -zxvf hdf5-1.8.20.tar.gz
    cd hdf5-1.8.20/ 
    ./configure --prefix=$NETCDF_INSTALL_PREFIX --with-zlib=$NETCDF_INSTALL_PREFIX --enable-fortran --enable-shared=no --enable-static-exec 
    make -j$NPROC && make check && make install 

    #Install netcdf-c
    cd $NETCDF_INSTALL_PKG
    tar -zxvf netcdf-c-4.4.1.tar.gz
    cd netcdf-c-4.4.1/ 
    CPPFLAGS=-I$NETCDF_INSTALL_PREFIX/include LDFLAGS=-L$NETCDF_INSTALL_PREFIX/lib ./configure --prefix=$NETCDF_INSTALL_PREFIX --disable-dap --enable-shared=no --disable-netcdf4
    make -j$NPROC && make check && make install 

    #Install netcdf-fortran
    cd $NETCDF_INSTALL_PKG
    tar -zxvf netcdf-fortran-4.4.1.tar.gz
    cd netcdf-fortran-4.4.1/ || exit
    CPPFLAGS=-I$NETCDF_INSTALL_PREFIX/include LDFLAGS=-L$NETCDF_INSTALL_PREFIX/lib LD_LIBRARY_PATH=$NETCDF_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" ./configure --prefix=$NETCDF_INSTALL_PREFIX --disable-dap --enable-shared=no --disable-netcdf4
    make -j$NPROC && make check && make install 

运行`build-netcdf.sh`

    ./build-netcdf.sh