#!/usr/bin/env python

import sys
import re

visited = set()
depth = 0

def trackIncludes(fileName):
  global visited, depth
  source = open(fileName).read()
  includes = re.findall('^ *#include *"(.*?)" *$', source, re.MULTILINE)
  for i in includes:
    if i not in visited:
      visited.add(i)
      print depth*' ' + i
      depth += 1
      trackIncludes(i)
      depth -= 1

if __name__ == '__main__':
  if len(sys.argv) != 2:
    sys.stderr.write('usage: ' + sys.argv[0] + ' rootFile\n')
    sys.exit(1)

  rootFile = sys.argv[1]

  trackIncludes(rootFile)

