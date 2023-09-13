#!/usr/bin/python

# Script, which prints focused window title to stdout.
# by abxh

from i3ipc import Connection

def get_focused_window_title(ipc):
    return ipc.get_tree().find_focused().window_title


def main():
    ipc = Connection()
    focused_window_title = get_focused_window_title(ipc)
    if focused_window_title is not None:
        print(focused_window_title)
    else:
        print('')

if __name__ == "__main__":
    main()
