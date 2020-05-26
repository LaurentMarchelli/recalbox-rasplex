# Recalplex
NOOBS distribution with Recalbox and Rasplex (formerly called recalbox-rasplex)

## Presentation
The aim of Recalplex is to produce a NOOBS distribution able to automatically install and configure at least Recalbox (http://www.recalbox.com/) and RasPlex (http://www.rasplex.com/) systems on the same RaspberryPi SD card.  (https://www.raspberrypi.org/)

Recalplex is a hack of Buildroot (https://buildroot.org/) using its scripts to download, expand and configure existing system images for your hardware configuration. Unlike BuildRoot it does not build any system from sources, but get released images from NOOBS, Recalbox and Rasplex update sites.

## Current version
- Noobs Lite v2.1
- Recalbox 6.1.1-Dragonblaze (Latest)
- Rasplex 1.8.0-148 (Latest)
  - Aeon Nox 5.4.0 (Latest)

## System requirements
Because Recalplex is made on Buildroot, it is designed to run on Linux Systems.
If may run on WLS (Windows Linux Subsystem) without any waranty; any feedback is welcome.
However, if you are using an other system (Windows, Macosx) configuring a Linux Virtual Machine could be a good option. (https://www.virtualbox.org/)

## How to use
01 - Install needed dependencies (e.g. Ubuntu)
```bash
sudo apt-get -y install make gcc g++ python unzip bc git libncurses-dev xz-utils
```

02 - Get the sources :
```bash
git clone --recursive https://gitlab.com/recalplex/recalplex.git
```

03 - Configure Recalplex
```bash
cd recalplex
make menuconfig
```

04 - Select your hardware (Target Architecture)
```
- Raspberry Pi 3 Model B (default)
- Raspberry Pi 2 Model B
- Raspberry Pi 1 Model B+
```

05 - Select your Powerswitch hardware
```
- RemotePi Board for Pi3, Pi 2 and B+ (default)
- RemotePi Board 2013
- None
```
Further informations at http://www.msldigital.com/

06 - Select your Rasplex skin
```
- Plex Black Edition Skin - Custom (default)
- Aeon Nox 5 - Custom
- OpenPHT - Standard
```

07 - Build NOOBS needed files
```bash
make
```

08 - Format a SD-Card with a unique Fat-32 bits partition in a msdos partition table

09 - Copy the content of the ./output/target directory into your SD-Card

10 - Insert the SD-Card into the Raspberry Pi

11 - Boot and select NOOBS options.

https://github.com/raspberrypi/noobs

## How it works
If you selected both Rasplex and Recalbox and you choose a customized skin (Plex Black Edition or Aeon Nox 5) :
- On Rasplex, you will have a new button (section) to reboot on Recalbox
- On Recalbox to reboot on Rasplex, just reboot.
(If Recalbox updates are downloaded, it will reboot on Recalbox to finish the update)

If you selected both Rasplex and Recalbox and you choose the standard skin (OpenPHT) you will have the noobs main menu to select which partittion you want to boot.

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

### Recalbox

Redistribution and use of the RECALBOX code or any derivative works are permitted provided that the following conditions are met:

* Redistributions may not be sold without authorization, nor may they be used in a commercial product or activity.
* Redistributions that are modified from the original source must include the complete source code, including the source code for all components used by a binary built from the modified sources.
* Redistributions must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

https://gitlab.com/recalbox/recalbox/-/blob/master/LICENSE.md

## Rasplex / OpenELEC
GNU GENERAL PUBLIC LICENSE Version 2, June 1991

https://opensource.org/licenses/GPL-2.0

https://github.com/RasPlex/OpenELEC.tv
