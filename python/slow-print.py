#!/usr/bin/env python

import sys
import time

sleepTime = 0.1 if len(sys.argv) < 2 else float(sys.argv[1])

while True:
  line = sys.stdin.readline()
  if line == '': break

  sys.stdout.write(line)
  time.sleep(sleepTime)

