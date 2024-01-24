# Software Setup and Preliminaries

## Using the Matter Accessory Device (MAD) Pre-Built Binaries

If you are just running the Matter demo, and are not interested in building the
Matter Accessory Device images from scratch, you can download the MAD images for
Wi-Fi from this software release on the
[Matter Artifacts Page](../general/ARTIFACTS.md)

Once you have downloaded the image you require for your device, you can skip
forward to the [Running the Matter Demo over Wi-Fi page](./RUN_DEMO.md)

Otherwise if you are planning to build the Wi-Fi images from scratch please
continue with this documentation.

## Software Setup

If you have not downloaded or cloned this repository, you can run the following
commands on a Linux terminal running on either Linux machine, WSL or Virtual
Machine to clone the repository and run bootstrap to prepare to build the sample
application images.

1. To download the
   [SiliconLabs Matter codebase](https://github.com/SiliconLabs/matter.git) run
   the following commands. Create a working directory named `git`:

    > `$ mkdir git`

    > `$ cd git`

    > `$ MATTER_WORKDIR=git` &emsp;&emsp; --> We will use $MATTER_WORKDIR later

    > `$ git clone https://github.com/SiliconLabs/matter.git`

2. Bootstrapping:

    > `$ cd matter`

    > `$ ./scripts/checkout_submodules.py --shallow --recursive --platform efr32`

    > `$ . scripts/bootstrap.sh`

    Create a directory where binaries will be updated/compiled called `out`:

    > `$ mkdir out`

<br>

## Building Software

The following commands are for building the example. Depending on which device
you are using, select the appropriate build command to run.

Build command for RS911x:

> `$ ./scripts/examples/gn_efr32_example.sh examples/lighting-app/efr32/ out/rs911x_lighting BRD4161A --wifi rs911x |& tee out/rs911x_lighting.out`

Build command for WF200:

> `$ ./scripts/examples/gn_efr32_example.sh examples/lighting-app/efr32/ out/wf200_lighting BRD4161A is_debug=false --wifi wf200 |& tee out/rs911x_lighting.out`

Run the following:

> `$ cd matter`

> `$ <appropriate_build_command_from_above>`

The generated software can be found in `out/rs911x_xxx/BRD4161A/*.out` for the
RS9116 and in `out/wf200_xxx/BRD4161A/*.out` for the WF200.

This is what you will flash onto the EFR32. For more information on how to flash
the EFR32 please check out the page on
[Flashing a Silicon Labs Device](../general/FLASH_SILABS_DEVICE.md)

## Compiling the ChipTool

In order to control the Wi-Fi Matter Accessory Device you will have to compile
and run the ChipTool on either a Linux, Mac or Raspberry Pi. The ChipTool builds
faster on the Mac and Linux machines so that is recommended, but if you have
access to a Raspberry Pi that will work as well.

1. Build the Chip-Tool

    > `$ ./scripts/examples/gn_build_example.sh examples/chip-tool out/standalone`

    This will build chiptool in `out/standalone`.

    After this, follow the steps on the page
    '[Running the Matter Demo over Wi-Fi](RUN_DEMO.md)' to flash the binaries
    and execute the demo.

---

[Table of Contents](../README.md) | [Thread Demo](../thread/DEMO_OVERVIEW.md) |
[Wi-Fi Demo](./DEMO_OVERVIEW.md)
