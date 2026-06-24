# LWB for the DPP2 ComBoard (SX1262)

Low-Power Wireless Bus application for the DPP2 ComBoard.
Code compatible with the NUCLEO-L476RG + SX1262 devkit (SX1262MB2CAS or SX1262DVK1xAS) is available in the branch 'nucleo-devkit'.

A how-to guide is available in the [Flora wiki](https://gitlab.ethz.ch/tec/public/flora/wiki#clone-compile-run).

## Prerequisites

- **Toolchain**: GNU Arm Embedded Toolchain **9-2020-q2-update** (`arm-none-eabi-gcc`)
  - Download: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
  - The Flora library checks for GCC 7 at compile time. Using GCC 9 (9-2020-q2-update) will produce a harmless warning:
    ```
    Lib/flora_lib.h:96:2: warning: #warning "Compiler version has changed." [-Wcpp]
    ```
    This warning can be safely ignored.

## Clone

```bash
git clone --recurse-submodules git@github.com:chien-chia-huang/lwb.git
cd lwb
```

If you already cloned without `--recurse-submodules`:
```bash
git submodule update --init --recursive
```

## Build (local toolchain)

Requires the ARM toolchain installed locally. Artifacts go to `build/`.

```bash
make
```

Or specify the toolchain path explicitly:
```bash
make GCC_PATH=/path/to/gcc-arm-none-eabi-9-2020-q2-update/bin
```

Output files:
- `build/comboard_lwb.elf`
- `build/comboard_lwb.hex`
- `build/comboard_lwb.bin`

## Build with Docker

No local toolchain needed. Artifacts are copied to `build_docker/`.

```bash
make docker
```

Output files:
- `build_docker/comboard_lwb.elf`
- `build_docker/comboard_lwb.hex`
- `build_docker/comboard_lwb.bin`

This uses the exact 9-2020-q2-update toolchain for a reproducible build.

## Flash

Using JFlashLite, select **STM32L433CC** and flash the `.hex` file.

Flash from a local build:
```bash
make jflash
```

Flash from a Docker build:
```bash
make docker-jflash
```

## Build with STM32CubeIDE

- To run (build and flash) the LWB example, use the toolchain **GNU Tools for STM32 (9-2020-q2-update)**.
- To use SEGGER J-LINK in STM32CubeIDE, *libncurses5* must be installed:
  ```bash
  sudo apt install libncurses5
  ```
- Build the project in STM32CubeIDE.
- Using JFlashLite, select **STM32L433CC** and flash the `.hex` file. You can also use SEGGER J-LINK directly in STM32CubeIDE.

## Configure LWB example for two nodes

- The flag `FLOCKLAB` in `app_config.h` must be deactivated for running with experimental boards (not FlockLab).
- The **HOST** works as the **GATEWAY** of the communication.
- The **HOST_ID** must always be equal to 2, which means that NODE_ID of the GATEWAY is 2.
- Set **NODE_ID = 1** for the other node.

### Configuration for gateway

```c
/* network parameters */
#define HOST_ID                         2
#if !FLOCKLAB
#define NODE_ID                       HOST_ID
#endif /* FLOCKLAB */
#define IS_HOST                         (NODE_ID == host_id)
```

### Configuration for node

```c
/* network parameters */
#define HOST_ID                         2
#if !FLOCKLAB
#define NODE_ID                       1
#endif /* FLOCKLAB */
#define IS_HOST                         (NODE_ID == host_id)
```

## Testing

Use the serial console with the appropriate baud rate to check correct behaviour:
- **NODE_ID=1** creates a package and sends it to the GATEWAY (NODE_ID = 2).
- The gateway prints: `lwb: data received from node 1`.

> The UART baud rate depends on the FLOCKLAB flag (see `main.c`):
> - FLOCKLAB = 0 &rarr; 1000000
> - FLOCKLAB = 1 &rarr; 460800

## Running an experiment on FlockLab

The `run_flocklab_test.sh` script configures the XML from `app_config.h`.

## Documentation

- DPP2 Dev Board:
  - https://www.research-collection.ethz.ch/bitstream/handle/20.500.11850/338855/IPSN2019_DPP_Demo.pdf
  - https://gitlab.ethz.ch/tec/public/dpp/dpp/-/wikis/Application/DevBoard
