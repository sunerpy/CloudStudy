#!/usr/bin/python
import sys
help_text="""Just a test script

Here is help document:
script.py info: get information
script.py ip: get system ip
script.py name: write your name to file
script.py run: run som command """
print(help_text)

if (sys.argv[1] == "ip"):
    print("ip")
print(sys.argv)
print(sys.argv[1])

