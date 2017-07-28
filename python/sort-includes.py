#!/usr/bin/env python

import sys
import re

def sortIncludes(includes):
  lines = includes.group(0).split('\n')[:-1]
  return '\n'.join(sorted(lines,
      key = lambda line: re.sub('#include ?(?:"|<)(.*)(?:"|>).*', '\\1', line).split('/')
    )) + '\n'

if __name__ == '__main__':
  if len(sys.argv) != 3:
    sys.stderr.write('usage: ' + sys.argv[0] + ' inputFile outputFile\n')
    sys.exit(1)

  inputFile = sys.argv[1]
  outputFile = sys.argv[2]

  source = open(inputFile).read()

  source = re.sub('(#include.*\n)+', sortIncludes, source)

  open(outputFile, 'w').write(source)

