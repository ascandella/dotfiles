#!/usr/bin/env python3

"""
Usage:
    rotate.py [options]

Options:
    -h,--help        display help message
    --version        display version and exit
"""

import dbus
import time
import subprocess
import socket
import logging
import docopt
import multiprocessing
import os
import signal
import atexit
from gi.repository import GLib
from dbus.mainloop.glib import DBusGMainLoop

name = "thinkpad_x1_yoga_rotation"
version = "0.9-SNAPSHOT"

# map sensor-proxy orientation to xrandr and wacom
xrandr_orientation_map = {
    'right-up': 'right',
    'normal': 'normal',
    'bottom-up': 'inverted',
    'left-up': 'left'
}

wacom_orientation_map = {
    'right-up': 'cw',
    'normal': 'none',
    'bottom-up': 'half',
    'left-up': 'ccw'
}


def cmd_and_log(cmd):
    exit = subprocess.call(cmd)
    log.info("running %s with exit code %s", cmd, exit)


def sensor_proxy_signal_handler(source, changedProperties, invalidatedProperties, **kwargs):
    if source == 'net.hadess.SensorProxy':
        if 'AccelerometerOrientation' in changedProperties:
            orientation = changedProperties['AccelerometerOrientation']
            log.info("dbus signal indicates orientation change to %s", orientation)
            subprocess.call(
                ["xrandr", "-o", xrandr_orientation_map[orientation]])
            for device in wacom:
                cmd_and_log(["xsetwacom", "--set", device, "rotate",
                             wacom_orientation_map[orientation]])
            subprocess.call(
                ["pkill", "-USR1", "-x", "polybar"])

# toggle trackpoint and touchpad when changing from laptop to tablet mode anc vice versa


def monitor_acpi_events(touch_and_track):
    socketACPI = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    socketACPI.connect("/var/run/acpid.socket")

    is_laptop_mode = True
    log.info("connected to acpi socket %s", socket)
    onboard_pid = None
    while True:
        event = socketACPI.recv(4096)
        log.debug("catching acpi event %s", event)
        #eventACPIDisplayPositionChange = "ibm/hotkey LEN0068:00 00000080 000060c0\n"
        eventACPIDisplayPositionChange = b" PNP0C14:03 000000b0 00000000\n"
        if event == eventACPIDisplayPositionChange:
            is_laptop_mode = not is_laptop_mode
            log.info(
                "display position change detected, laptop mode %s", is_laptop_mode)
            if is_laptop_mode:
                for x in touch_and_track:
                    cmd_and_log(["xinput", "enable", x])
                log.info("onboard pid %s", onboard_pid)
                if onboard_pid:
                    log.info("stopping onboard")
                    os.kill(onboard_pid, signal.SIGTERM)
            else:
                for x in touch_and_track:
                    cmd_and_log(["xinput", "disable", x])
                #subprocess.call(["xinput", "--disable", "SynPS/2 Synaptics TouchPad"])
                p = subprocess.Popen(['nohup', 'onboard'],
                                     stdout=open('/dev/null', 'w'),
                                     #stderr=open('logfile.log', 'a'),
                                     preexec_fn=os.setpgrp
                                     )
                onboard_pid = p.pid
                log.info("started onboard with pid %s", onboard_pid)
        time.sleep(0.3)


def monitor_stylus_proximity(stylus, finger_touch):
    out = subprocess.Popen(
        ["xinput", "test", "-proximity", stylus], stdout=subprocess.PIPE)
    for line in out.stdout:
        if (line.startswith(b'proximity')):
            log.debug(line)
            status = line.split(b' ')[1]
            cmd_and_log(["xinput", "disable" if status ==
                         b'in' else "enable", finger_touch])


def cleanup(touch_and_track, wacom):
    subprocess.call(["xrandr", "-o", "normal", "--auto"])
    for x in touch_and_track:
        cmd_and_log(["xinput", "enable", x])
    for device in wacom:
        cmd_and_log(["xsetwacom", "--set", device, "rotate", "none"])


def main(options):

    # logging
    global log
    log = logging.getLogger()
    logHandler = logging.StreamHandler()
    log.addHandler(logHandler)
    logHandler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
    log.level = logging.INFO

    # load wacom devices
    lines = subprocess.check_output(
        ['xsetwacom', '--list', 'devices']).split(b'\n')

    global wacom
    wacom = [x.decode().split('\t')[0] for x in lines if x]
    log.info("detected wacom devices: %s", wacom)

    # load stylus touchpad trackpoint devices
    lines = subprocess.check_output(
        ['xinput', '--list', '--name-only']).decode().split('\n')

    stylus = next(x for x in lines if "stylus" in x)
    log.info("found stylus %s", stylus)

    finger_touch = next(x for x in lines if "Finger touch" in x)
    log.info("found finger touch %s", finger_touch)

    # it's crucial to have trackpoints first in this list. Otherwise enabling/disabling doesn't work as expected and touchpad just stays enabled always
    touch_and_track = [x for x in lines if "TrackPoint" in x] + \
        [x for x in lines if "TouchPad" in x]
    log.info("found touchpad and trackpoints %s", touch_and_track)

    # listen for ACPI events to detect switching between laptop/tablet mode
    acpi_process = multiprocessing.Process(
        target=monitor_acpi_events, args=(touch_and_track,))
    acpi_process.start()

    proximity_process = multiprocessing.Process(
        target=monitor_stylus_proximity, args=(stylus, finger_touch))
    proximity_process.start()

    atexit.register(cleanup, touch_and_track, wacom)

    # init dbus stuff and subscribe to events
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    proxy = bus.get_object('net.hadess.SensorProxy', '/net/hadess/SensorProxy')
    props = dbus.Interface(proxy, 'org.freedesktop.DBus.Properties')
    props.connect_to_signal(
        'PropertiesChanged', sensor_proxy_signal_handler, sender_keyword='sender')
    iface = dbus.Interface(proxy, 'net.hadess.SensorProxy')
    iface.ClaimAccelerometer()
    # iface.ClaimLight()

    loop = GLib.MainLoop()
    loop.run()


if __name__ == "__main__":
    options = docopt.docopt(__doc__)
    if options["--version"]:
        print(version)
        exit()
    main(options)
