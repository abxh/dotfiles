#!/usr/bin/python

# automatically name workspaces based on the windows in the workspaces.

# Dependencies:
# * python-i3ipc

# sources:
# https://github.com/walshc/i3/blob/master/scripts/autoname-workspaces.py
# https://github.com/swaywm/sway/blob/master/contrib/autoname-workspaces.py

import signal
import sys

from i3ipc import Connection, Event

WINDOW_ICONS = {
    "alacritty": "",
    # "firefox": "",
    "code-oss": "",
    "qutebrowser": "Q",
    "arandr": "",
    "lxappearance": "",
}

DEFAULT_ICON = ""

REMOVE_DUPLICATES = False


def icon_for_window(window):
    window = window.lower()
    if window in WINDOW_ICONS:
        return WINDOW_ICONS[window]
    else:
        print(f"No icon available for window with classes: {window}")
        return DEFAULT_ICON


def get_windows(workspace):
    windows = [w.window_class for w in workspace.leaves()]
    if REMOVE_DUPLICATES:
        return set(windows)
    else:
        return windows


def rename_workspaces(ipc):
    for workspace in ipc.get_tree().workspaces():
        icons = [icon_for_window(window) for window in get_windows(workspace)]
        icons_str = ": " + " ".join(icons) if len(icons) else ""
        new_name = str(workspace.num) + icons_str

        ipc.command(f'rename workspace "{workspace.name}" to "{new_name}"')


def main():
    ipc = Connection()

    # Run function once before waiting for event change.
    rename_workspaces(ipc)

    # Rename workspaces to their defaults, when exited.
    def signal_handler(signal, frame):
        for workspace in ipc.get_tree().workspaces():
            ipc.command(f'rename workspace "{workspace.name}" to "{workspace.num}"')
        ipc.main_quit()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    # On event change
    def on_change(ipc, e):
        if e.change in ["new", "close", "move"]:
            rename_workspaces(ipc)

    ipc.on(Event.WINDOW, on_change)
    ipc.main()


if __name__ == "__main__":
    main()
