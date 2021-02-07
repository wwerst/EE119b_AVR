# EE119b_AVR
Repo for AVR instruction set test and implementation in VHDL


# Setup

This project targets the AT90S4414 device. In order to run assembly simulator for this device,
you need to install AVR Studio 4? (verifying this now). Newer versions deprecate support.

# Running Tests

Once you have GHDL and osvvm installed, run commands from the Makefile:

## Import vhdl files

```
make import
```

## Run tests

Test memory access unit (mau):

```
make mau_tests
```

Test general purpose registers:

```
make avr_reg_tests
```

# GDHL Install

For simulation, this code uses GHDL. Install GHDL from pre-built binaries (available online), or,
alternatively, build from source.

```
apt update
apt install -y gnat
git clone git@github.com:ghdl/ghdl
cd ghdl
git checkout v0.37.0
./configure --prefix=/usr/local
make
```

Then, install the built code. I prefer to use checkinstall to wrap packages, but you can also just directly do `make install`.

You will also want to install gtkwave to visualize the tests:

```
apt install gtkwave
```

After doing all this, go through Quick Start Guide to learn basics: https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html

# OSVVM Install

See this link: https://ghdl.readthedocs.io/en/stable/building/PrecompileVendorPrimitives.html?highlight=osvvm

Summary of instructions:
- Clone osvvm repo to a folder on your computer
- modify config.sh file of ghdl to point to the ossvm cloned repo for osvvm source
- run compile-osvvm script in ghdl. This script will compile osvvm and put an osvvm folder in your current folder. Run this in root

See the above link for original source docs that will (hopefully) be kept up to date.
