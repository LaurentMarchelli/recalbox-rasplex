# recalbox-rasplex
NOOBS distribution with Recalbox and Rasplex

## Presentation
The aim of recalbox-rasplex is to produce a NOOBS distribution able to automatically install and configure at least Recalbox-OS (http://www.recalbox.com/) and RasPlex (http://www.rasplex.com/) systems on the same RaspberryPi SD card.  (https://www.raspberrypi.org/)

Recalbox-rasplex is a hack of Buildroot (https://buildroot.org/) using its scripts to download, expand and configure existing system images for your hardware configuration. Unlike BuildRoot it does not build any system from sources, but get released images from NOOBS, Recalbox-OS and Rasplex update sites.

## Current version
- Noobs v1.9.3
- Recalbox-OS (one of following)
  - v4.0.0-beta5 (default)
  - v4.0 last unstable build
  - v4.1 last unstable build
- Rasplex v1.6.2

## System requirements
Because recalbox-rasplex is made on Buildroot, it is designed to run on Linux Systems.
If you are using an other system (Windows, Macosx) configuring a Linux Virtual Machine could be a good option. (https://www.virtualbox.org/)

## How to use
1 - Install needed dependencies (e.g. Ubuntu)
```bash
sudo apt-get -y install git libncurses-dev
```
2 - Get the sources :
```bash
git clone --recursive https://github.com/LaurentMarchelli/recalbox-rasplex.git
```
3 - Configure recalbox-rasplex
```bash
cd recalbox-rasplex
make menuconfig
```
4 - Select your hardware (Target Architecture)
```
- Raspberry Pi 1 Model B+
- Raspberry Pi 2 Model B
- Raspberry Pi 3 Model B
```
5 - Select your Powerswitch hardware
```
- None
- RemotePi Board 2013
- RemotePi Board for Pi3, Pi 2 and B+
```
Further informations at http://www.msldigital.com/

6 - Select your Recalbox Version
```
- Version 4.0 - Stable
- Version 4.0 - Unstable
- Version 4.1 - Unstable
- None
```
7 - Select further available options

8 - Build NOOBS needed files
```bash
make
```
9 - Format a SD-Card with a unique Fat-32 bits partition in a msdos partition table

10 - Copy the content of the ./output/target directory into your SD-Card

11 - Insert the SD-Card into the Raspberry Pi

11 - Boot and select NOOBS options.

https://github.com/raspberrypi/noobs

## Licenses
### BuildRoot 
GNU GENERAL PUBLIC LICENSE Version 2, June 1991

https://opensource.org/licenses/GPL-2.0

### NOOBS
Copyright (c) 2013, Raspberry Pi
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the Raspberry Pi Foundation nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

https://github.com/raspberrypi/noobs

### Recalbox-OS
License Redistribution and use of the RECALBOX code or any derivative works are permitted provided that the following conditions are met:

Redistributions may not be sold without authorization, nor may they be used in a commercial product or activity. Redistributions that are modified from the original source must include the complete source code, including the source code for all components used by a binary built from the modified sources.

Redistributions must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

https://github.com/recalbox/recalbox-os/blob/master/LICENCE.md

## Rasplex / OpenELEC
GNU GENERAL PUBLIC LICENSE Version 2, June 1991

https://opensource.org/licenses/GPL-2.0

https://github.com/RasPlex/OpenELEC.tv
