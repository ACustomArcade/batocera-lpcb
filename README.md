# batocera-lpcb

LPCB installer for Batocera.

Currently supports the following devices:
* Raspberry Pi 4

To install, [SSH to your device](https://wiki.batocera.org/access_the_batocera_via_ssh) and run the following command:

`bash <(curl -s https://raw.githubusercontent.com/ACustomArcade/batocera-lpcb/main/setup.sh)`

That's it! Your ALU volume buttons should be working as expected in Batocera with an added extra. Hit Volume Up and Volume Down at the same time to toggle mute.

## Known Issues
- ALU controller is not auto-detected. We're trying to figure out the magic sauce in Batocera we can contribute upstream so this is automatic.
- BitPixel/Pixelcade is not auto-installed. It's currently separate.
