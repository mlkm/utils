#!/usr/bin/env python

import re
import sys
import os

colorMapping = {
  'txtblk' : '0;30m', # Black - Regular
  'txtred' : '0;31m', # Red
  'txtgrn' : '0;32m', # Green
  'txtylw' : '0;33m', # Yellow
  'txtblu' : '0;34m', # Blue
  'txtpur' : '0;35m', # Purple
  'txtcyn' : '0;36m', # Cyan
  'txtwht' : '0;37m', # White
  'bldblk' : '1;30m', # Black - Bold
  'bldred' : '1;31m', # Red
  'bldgrn' : '1;32m', # Green
  'bldylw' : '1;33m', # Yellow
  'bldblu' : '1;34m', # Blue
  'bldpur' : '1;35m', # Purple
  'bldcyn' : '1;36m', # Cyan
  'bldwht' : '1;37m', # White
  'undblk' : '4;30m', # Black - Underline
  'undred' : '4;31m', # Red
  'undgrn' : '4;32m', # Green
  'undylw' : '4;33m', # Yellow
  'undblu' : '4;34m', # Blue
  'undpur' : '4;35m', # Purple
  'undcyn' : '4;36m', # Cyan
  'undwht' : '4;37m', # White
  'bakblk' : '40m',   # Black - Background
  'bakred' : '41m',   # Red
  'bakgrn' : '42m',   # Green
  'bakylw' : '43m',   # Yellow
  'bakblu' : '44m',   # Blue
  'bakpur' : '45m',   # Purple
  'bakcyn' : '46m',   # Cyan
  'bakwht' : '47m',   # White
  'txtrst' : '0m',    # Text Reset

  'cursav' : 's',     # Save cursor position
  'curres' : 'u',     # Restore cursor position
}

if __name__ == '__main__':
  assert len(sys.argv) % 2 == 1

  rules = zip(
    sys.argv[1::2],
    sys.argv[2::2]
  )

  while True:
    line = sys.stdin.readline()
    if line == '': break

    coloredSegments = []
    for rule in rules:
      for match in re.finditer(rule[0], line):
        span = (-1, -1)
        try: span = match.span(1)
        except IndexError: span = match.span()

        coloredSegments += [(span, rule[1].split(','))]

    coloredSegments = map(lambda seg: (
      seg[0],
      map(lambda x: x if x not in colorMapping else colorMapping[x], seg[1])
    ), coloredSegments)

    coloredSegments = sorted(coloredSegments, key = lambda seg: seg[0])
    lastPrintedIndex = 0

    write = sys.stdout.write

    for segment in coloredSegments:
      write(line[lastPrintedIndex:segment[0][0]])
      write(reduce(lambda init, x: init +
              (('\x1b[' + x) if
              x[0] != '#' else
              x[1:].replace('~', ' ')),
              filter(lambda s: s != 'delete', segment[1]),
              ''))
      if 'delete' not in segment[1]:
        write(line[max(lastPrintedIndex, segment[0][0]):segment[0][1]])
      write('\x1b[0m')

      lastPrintedIndex = max(lastPrintedIndex, segment[0][1])

    write(line[lastPrintedIndex:])

