
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