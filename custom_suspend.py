#!/usr/bin/env python3

# This was originally authored by Kim Nguyễn
# https://bugs.launchpad.net/gnome-settings-daemon/+bug/1722286/comments/3

import dbus, subprocess
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

LID_CLOSE_BATTERY_ACTION="suspend"
LID_CLOSE_AC_ACTION="nothing"

class Action():
    def blank(self):
        return subprocess.call(['gnome-screensaver-command', '-a'])

    def suspend(self):
        return subprocess.call(['systemctl', 'suspend', '-i'])

    def shutdown(self):
        return subprocess.call(['systemctl', 'poweroff', '-i'])

    def hibernate(self):
        return subprocess.call(['systemctl', 'hibernate', '-i'])

    def interactive(self):
        return subprocess.call(['gnome-session-quit'])

    def nothing(self):
        return

    def logout(self):
        return subprocess.call(['gnome-session-quit', '--no-prompt'])

class CustomSuspendMonitor():
    DBUS_UPOWER_PATH = '/org/freedesktop/UPower'
    DBUS_UPOWER_BUS = 'org.freedesktop.UPower'
    DBUS_PROPERTIES_IFACE = 'org.freedesktop.DBus.Properties'

    UPOWER_LID_CLOSED = 'LidIsClosed'
    UPOWER_ON_BATTERY = 'OnBattery'
    DBUS_PROPERTIES_CHANGED = 'PropertiesChanged'

    action = Action()
    on_battery = False
    lid_closed = False
    bus = None

    def __init__(self):
        DBusGMainLoop(set_as_default=True)
        self.bus = dbus.SystemBus()

    def init_status (self):
        upower_object = self.bus.get_object (self.DBUS_UPOWER_BUS, self.DBUS_UPOWER_PATH)
        upower_intf = dbus.Interface (upower_object, self.DBUS_PROPERTIES_IFACE)
        self.lid_closed = upower_intf.Get(self.DBUS_UPOWER_BUS, self.UPOWER_LID_CLOSED)
        self.on_battery = upower_intf.Get(self.DBUS_UPOWER_BUS, self.UPOWER_ON_BATTERY)


    def perform_action (self,msg):
        getattr(self.action, msg)()
        self.init_status()   # in case the user plugged/unplugged during suspend or hibernate

    def apply_policy (self):
        if self.lid_closed:
            action = ""
            if self.on_battery:
                action = LID_CLOSE_BATTERY_ACTION
            else:
                action = LID_CLOSE_AC_ACTION

            self.perform_action(action)

    def handle_prop_changed(self,arg1, arg2, arg3):
        for key in arg2:
            if key == self.UPOWER_LID_CLOSED:
                self.lid_closed = arg2[key]
            elif  key == self.UPOWER_ON_BATTERY:
                self.on_battery = arg2[key]
        self.apply_policy()

    def start (self):
        self.init_status()
        self.apply_policy()
        self.bus.add_signal_receiver (lambda a,b,c: self.handle_prop_changed(a,b,c) ,
                                 self.DBUS_PROPERTIES_CHANGED,
                                 self.DBUS_PROPERTIES_IFACE,
                                 self.DBUS_UPOWER_BUS,
                                 self.DBUS_UPOWER_PATH)
        loop = GLib.MainLoop()
        try:
            loop.run()
        except (KeyboardInterrupt, SystemExit):
            return

if __name__ == '__main__':
    CustomSuspendMonitor().start()
