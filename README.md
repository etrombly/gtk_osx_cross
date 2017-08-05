# gtk_osx_cross
scripts to setup gtk to cross compile from linux

\# modified from osxcross-git aur package

    git clone https://github.com/tpoechtrager/osxcross
    cd osxcross
    wget https://s3.dockerproject.org/darwin/v2/MacOSX10.11.sdk.tar.xz
    mv MacOSX10.11.sdk.tar.xz tarballs/
    sed -i -e 's|-march=native||g' build_clang.sh wrapper/build.sh
    UNATTENDED=yes OSX_VERSION_MIN=10.6 ./build.sh

build gcc

    copy ubsan.c.patch to patches
    copy build_gcc.sh to .

    GCC_VERSION=6.3.0 ./build_gcc.sh
    mkdir -p /usr/local/osx-ndk-x86
    mv target/* /usr/local/osx-ndk-x86

try to get gtk to compile

    now install jhbuild

    ./gtk-osx-build-setup.sh
    cp jhbuildrc ~/.jhbuildrc
    jhbuild shell
    export PATH=/usr/local/osx-ndk-x86/bin:$PATH
    
    # hack, need to find a better way to do this
    ln -s /usr/local/osx-ndk-x86/SDK/MacOSX10.11.sdk/System /System
    
    jhbuild bootstrap #will fail
    edit ~/gtk/source/xz-5.2.3/configure, delete "-m elf_x86_64" from linker config
