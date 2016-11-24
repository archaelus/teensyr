# Using Zinc Externally with a Teensy 3.1 or 3.2

This project is an example of how you can setup an external project
using [Zinc](https://www.github.com/hackndev/zinc) to target the Teensy.  The actual example used here is one
taken from the Zinc examples, but with this infrastructure in place,
you can create whatever you want.

## Pre-requisites

### OS X

* [Install rustup](https://www.rustup.rs)
  * `$ rustup update nightly-2016-05-12`
  * In your project dir: `$ rustup override set nightly-2016-05-12`
* Install `arm-none-eabi` gcc suite (for cortex-m4)
  * `$ brew cask install gcc-arm-embedded`
* Setup the `thumbv7em-none-eabi` target
  * `$ echo -e '[target.thumbv7em-none-eabi]\nlinker = "arm-none-eabi-gcc"\nar = "arm-none-eabi-ar"\n' >> ~/.cargo/config`
* Install the [Teensy Loader CLI](https://www.pjrc.com/teensy/loader_cli.html)
  * `$ brew install -dv --HEAD teensy_loader_cli`

## Building the Example

The code can be built with cargo.

```
$ cargo build --release --target=thumbv7em-none-eabi
```

This will generate an object file, to turn this into a bin file or hex
file you will need to run objdump on the resultant binary.  E.g.

```
$ objdump -O ihex ./target/thumbv7em-none-eabi/release/blink blink.hex
```

Since you are like to need to type this quite frequently, you may want
to create a [Makefile like this one](Makefile) to reduce the number
of commands you need to type.

### Flashing the Teensy

```
$ teensy_loader_cli -s --mcu=mk20dx256 -v ./target/thumbv7em-none-eabi/release/blink.hex
Teensy Loader, Command Line, Version 2.0
Read "target/thumbv7em-none-eabi/release/blink.hex": 3236 bytes, 1.2% usage
Soft reboot is not implemented for OSX
Waiting for Teensy device...
 (hint: press the reset button)
Found HalfKay Bootloader
Read "target/thumbv7em-none-eabi/release/blink.hex": 3236 bytes, 1.2% usage
Programming....
Booting
```

## Creating Your Own Project Using Zinc

### Step 1: Create a new rust project

```
$ rust new --bin --vcs git rust-teensy3-blink
$ cd rust-teensy-blink
```

### Step 2: Set up your Cargo.toml

Add the following to Cargo.toml, replacing the information preset here
with information that makes sense for your MCU, binary, etc.

```toml
[package]
name = "rust-teensy3-blink"
version = "0.1.0"
authors = [YOU, "Geoff Cant <nem@erlang.geek.nz>", "Paul Osborne <osbpau@gmail.com>"]

[dependencies.zinc]
git = "https://github.com/Gyscos/zinc.git"
branch = "crazy"
features = ["mcu_k20"]

[dependencies.macro_platformtree]
git = "https://github.com/Gyscos/zinc.git"
branch = "crazy"
path = "macro_platformtree"

[dependencies.ioreg]
git = "https://github.com/Gyscos/zinc.git"
branch = "crazy"
path = "ioreg"

[dependencies.platformtree]
git = "https://github.com/Gyscos/zinc.git"
branch = "crazy"
path = "platformtree"

[dependencies.rust-libcore]
version = "*"

[[bin]]
name = "blink"
path = "blink.rs"
```

### Step 3: Grab a target specification

Grab a suitable target specification from those available in the root
of the Zinc repository (`thumbv7em-none-eabi.json` for the Teensy 3.1 and 3.2).

### Step 4: Tell rust about your toolchain

This usually requires putting a couple lines like this in your
`.cargo/config` so that Rust knows to use a proper cross-linker for
your target:

```toml
[target.thumbv7em-none-eabi]
linker = "arm-none-eabi-gcc"
ar = "arm-none-eabi-ar"

[target.thumbv7m-none-eabi]
linker = "arm-none-eabi-gcc"
ar = "arm-none-eabi-ar"
```

### Step 4: Automate artifact generation

You can start with the [Makefile from the example](Makefile) and go
from there.

### Step 5: Create!

Write your code using Zinc!
