# gtk_osx_cross
scripts to setup gtk to cross compile from linux

install osxcross (modified from osxcross-git aur package)

    git clone https://github.com/tpoechtrager/osxcross
    cd osxcross
    wget https://s3.dockerproject.org/darwin/v2/MacOSX10.11.sdk.tar.xz
    mv MacOSX10.11.sdk.tar.xz tarballs/
    sed -i -e 's|-march=native||g' build_clang.sh wrapper/build.sh
    UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

build gcc (can skip if not building gtk)

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

now install jhbuild, clone this repo first gtk-osx-build-setup.sh, and jhbuildrc are needed in the following steps.

    pacaur -S jhbuild
    bash gtk-osx-build-setup.sh
    cp jhbuildrc ~/.jhbuildrc    

install gtk

    jhbuild shell
    export PATH=/usr/local/osx-ndk-x86/bin:$PATH
    
    # hack, need to find a better way to do this
    ln -s /usr/local/osx-ndk-x86/SDK/MacOSX10.11.sdk/System /System
    
    jhbuild bootstrap 
    # the bootstrap will fail because the linker says -m is deprecated, will probably need to do the next step for each library
    sed -i -e 's|-m elf_x86_64||g' ~/gtk/source/xz-5.2.3/configure
    ~/.cache/jhbuild/build/xz-5.2.3/libtool set line 109 max_cmd_len=255
    jhbuild bootstrap #again
    # links after this but can't find the liblzma.so file, the build script tries to link it to liblzma.so.5.2.3, but it looks like it's never actually creating it 
