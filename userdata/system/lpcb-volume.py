#!/usr/bin/python
import subprocess

from signal import pause

import RPi.GPIO as GPIO


def volume_up(channel):
  subprocess.run(["batocera-audio", "setSystemVolume", "+5"])


def volume_down(channel):
  subprocess.run(["batocera-audio", "setSystemVolume", "-5"])


def volume_mute_toggle(channel):
  subprocess.run(["batocera-audio", "setSystemVolume", "mute-toggle"])


GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.setup([11, 13], GPIO.IN, pull_up_down=GPIO.PUD_UP)

GPIO.add_event_detect(11, GPIO.FALLING, callback=volume_down, bouncetime=500)
GPIO.add_event_detect(13, GPIO.FALLING, callback=volume_up, bouncetime=500)

while True:
  pause()
