# EE119b_AVR
Repo for AVR instruction set test and implementation in VHDL


# Setup

This project targets the AT90S4414 device. In order to run assembly simulator for this device,
you need to install AVR Studio 4? (verifying this now). Newer versions deprecate support.

# GDHL Install

For simulation, this code uses GHDL. Install GHDL from pre-built binaries (available online), or,
alternatively, build from source.

```
apt update
apt install -y gnat
git clone git@github.com:ghdl/ghdl
cd ghdl
./configure --prefix=/usr/local
make
```

Then, install the built code. I prefer to use checkinstall to wrap packages, but you can also just directly do `make install`.

You will also want to install gtkwave to visualize the tests:

```
apt install gtkwave
```

After doing all this, go through Quick Start Guide to learn basics: https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html

