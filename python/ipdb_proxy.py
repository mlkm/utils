import imp
import sys

def force_import_ipdb():
  old_executable, sys.executable = sys.executable, ''

  try:
    IPython = imp.load_module(
        'IPython',
        *imp.find_module(
            'IPython',
            ['/usr/local/lib/python2.7/dist-packages']))

    path = imp.load_module(
        'path',
        *imp.find_module(
            'path',
            ['/usr/local/lib/python2.7/dist-packages/IPython/utils']))

    loader = imp.load_module(
        'loader',
        *imp.find_module(
            'loader',
            ['/usr/local/lib/python2.7/dist-packages/IPython/config']))

    ipapp = imp.load_module(
        'ipapp',
        *imp.find_module(
            'ipapp',
            ['/usr/local/lib/python2.7/dist-packages/IPython/terminal']))

    global ipdb
    ipdb = imp.load_module(
        'ipdb',
        *imp.find_module(
            'ipdb',
            ['/usr/local/lib/python2.7/dist-packages']))

  finally:
    sys.executable = old_executable

force_import_ipdb()
from ipdb import *
