#!/bin/sh
#
# Script that sets up jhbuild for GTK+ OS X building. Run this to
# checkout jhbuild and the required configuration.
#
# Copyright 2007, 2008, 2009 Imendio AB
#
# Run this whenever you want to update jhbuild or the jhbuild setup;
# it is safe to run it repeatedly. Note that it overwrites
# ~/.jhbuildrc however. Custom settings should be kept in
# ~/.jhbuildrc-custom.
#
# You need Mac OS X 10.4 or newer and Xcode 2.5 or newer. Make sure
# you have subversion (svn) installed, 10.5 has it by default.
#
# Quick HOWTO:
#
# sh gtk-osx-build-setup.sh
#
# jhbuild bootstrap
# jhbuild build meta-gtk-osx-bootstrap
# jhbuild build
#
# See http://live.gnome.org/GTK%2B/OSX/Building for more information.
#

BASEURL="https://git.gnome.org/browse/gtk-osx/plain/"

do_exit()
{
    echo $1
    exit 1
}

get_moduleset_from_git()
{
    curl -ks "$BASEURL/modulesets-stable/$1" -o "${HOME}/jhbuild/modulesets/$1" || \
	do_exit "Unable to download $1"
}

mkdir -p "${HOME}/jhbuild/modulesets" 2>/dev/null || do_exit "The directory "${HOME}/jhbuild/modulesets" could not be created. Check permissions and try again."
mkdir -p "${HOME}/gtk/inst/include"
mkdir -p "${HOME}/gtk/inst/lib"

#If ~/.jhbuildrc is a link, assume that it's to a gtk-osx repository
#and don't touch it.
if [ ! -L $HOME/.jhbuildrc ]; then
    echo "Installing jhbuild configuration..."
    curl -ks $BASEURL/jhbuildrc-gtk-osx -o $HOME/.jhbuildrc || do_exit "Didn't get jhbuildrc"
    curl -ks $BASEURL/jhbuildrc-gtk-osx-fw-10.4 -o $HOME/.jhbuildrc-fw-10.4
    curl -ks $BASEURL/jhbuildrc-gtk-osx-cfw-10.4 -o $HOME/.jhbuildrc-cfw-10.4
    curl -ks $BASEURL/jhbuildrc-gtk-osx-cfw-10.4u -o $HOME/.jhbuildrc-cfw-10.4u
    curl -ks $BASEURL/jhbuildrc-gtk-osx-fw-10.4-test -o $HOME/.jhbuildrc-fw-10.4-test
fi
if [ ! -f $HOME/.jhbuildrc-custom ]; then
    curl -ks $BASEURL/jhbuildrc-gtk-osx-custom-example -o $HOME/.jhbuildrc-custom || do_exit "Didn't get jhbuildrc-custom"
fi

echo "Installing gtk-osx moduleset files..."
MODULES="bootstrap.modules gtk-osx-bootstrap.modules gtk-osx.modules gtk-osx-gstreamer.modules gtk-osx-gtkmm.modules gtk-osx-javascript.modules gtk-osx-network.modules gtk-osx-python.modules gtk-osx-random.modules gtk-osx-themes.modules gtk-osx-unsupported.modules"

for m in $MODULES; do
    get_moduleset_from_git $m
done

echo "Done."
