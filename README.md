# gtk_osx_cross
scripts to setup gtk to cross compile from linux

clone this repo first, ubsan.c.patch, build_gcc.sh, gtk-osx-build-setup.sh, and jhbuildrc are needed in the following steps.

install osxcross (modified from osxcross-git aur package)

    git clone https://github.com/tpoechtrager/osxcross
    cd osxcross
    wget https://s3.dockerproject.org/darwin/v2/MacOSX10.11.sdk.tar.xz
    mv MacOSX10.11.sdk.tar.xz tarballs/
    sed -i -e 's|-march=native||g' build_clang.sh wrapper/build.sh
    UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

build gcc (can skip if not building gtk)

    copy ubsan.c.patch to patches
    copy build_gcc.sh to .

    GCC_VERSION=6.3.0 ./build_gcc.sh

install osxcross

    sudo mkdir -p /usr/local/osx-ndk-x86
    sudo mv target/* /usr/local/osx-ndk-x86

setup rust toolchain

    rustup target add x86_64-apple-darwin

~/.cargo/conf

    [target.x86_64-apple-darwin]
    linker = "x86_64-apple-darwin15-gcc"
    ar = "x86_64-apple-darwin15-ar"

to cross compile a console program

    export PATH=/usr/local/osx-ndk-x86/bin:$PATH
    export PKG_CONFIG_ALLOW_CROSS=1
    cargo build --target=x86_64-apple-darwin --release

# try to get gtk to compile

now install jhbuild

    pacaur -S jhbuild

install gtk

    ./gtk-osx-build-setup.sh
    cp jhbuildrc ~/.jhbuildrc
    jhbuild shell
    export PATH=/usr/local/osx-ndk-x86/bin:$PATH
    
    # hack, need to find a better way to do this
    ln -s /usr/local/osx-ndk-x86/SDK/MacOSX10.11.sdk/System /System
    
    jhbuild bootstrap #will fail
    edit ~/gtk/source/xz-5.2.3/configure, delete "-m elf_x86_64" from linker config
