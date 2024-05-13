# Example

```
# Generate
slc generate efr32.slcp -d auto/brd4166a --with brd4166a
slc generate efr32.slcp -d auto/brd4186c --with brd4186c
slc generate si917.slcp -d auto/si917
slc generate si917.slcp -d auto/si917 --sdk /Volumes/Resources/git/matter/release/third_party/silabs/gecko_sdk

# Run from RAM
cp ram/efr32mg12.ld auto/brd4166a/autogen/linkerfile.ld
cp ram/efr32mg24.ld auto/brd4186c/autogen/linkerfile.ld

# Make
make -C auto/brd4166a -f blinky.Makefile
make -C auto/brd4186c -f blinky.Makefile
make -C auto/si917 -f blinky.Makefile

# Flash (ROM or RAM)
commander flash auto/brd4166a/build/debug/blinky.s37
commander flash auto/brd4186c/build/debug/blinky.s37
```