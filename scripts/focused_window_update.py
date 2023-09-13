#!/usr/bin/python

# Script, which updates i3blocks, when focused window title has changed.
# by abxh

from i3ipc import Connection,  Event
import subprocess

SIGNAL=10

def update_title():
    subprocess.run(["pkill","-SIGRTMIN+"+str(SIGNAL),"i3blocks"])

def main():
    update_title()
    
    ipc = Connection()

    def on_window_change(ipc, e):
        if e.change in ["focus","close","title"]:
            update_title()
    ipc.on(Event.WINDOW,on_window_change)
    
    def on_workspace_change(ipc, e):
        if e.change == "focus":
            update_title()
    ipc.on(Event.WORKSPACE,on_workspace_change)

    ipc.main()

if __name__ == "__main__": 
    main()
