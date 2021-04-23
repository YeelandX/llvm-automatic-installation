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

## 使用脚本安装

### 1. 选择安装目录
这里我们将安装在/yourpath/llvm目录下

    mkdir llvm && cd llvm

### 2. 把[脚本](https://github.com/YeelandX/llvm-automatic-installation/blob/main/llvm_auto_install.sh)拉到该目录下
:)你想咋拉都行


### 3. 修改脚本中的变量
平台架构`ARCH`

- default:X86

make -j`NPROC`

- default:4
- suggest:$(nproc)


cmake参数`cmake_options`
- 可参考[原文档](https://llvm.org/docs/CMake.html)
- 脚本默认设置的cmake参数
- `CMAKE_INSTALL_PREFIX`:安装路径，不指定则`/usr/local`，脚本中设置为`/yourpath/llvm/llvm_install`
- `LLVM_CONFIG`:llvm-config路径
- `CMAKE_CXX_COMPILER`:指定g++路径
- `CMAKE_C_COMPILER`:指定gcc路径
- `CMAKE_Fortran_COMPILER`:指定fortran编译器
- `LLVM_TARGETS_TO_BUILD`:目标平台的架构,脚本中设置为`x86`
- `CMAKE_BUILD_TYPE`:生成类型，默认是`debug`，脚本中设置为`release`
- 
- 使用非系统gcc/g++时要加上以下选项
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

不想写了。。。