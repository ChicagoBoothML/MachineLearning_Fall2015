from __future__ import print_function
from pprint import pprint
from sys import stdout


def printflush(*args, **kwargs):
    print(*args, **kwargs)
    stdout.flush()


def pprintflush(*args, **kwargs):
    pprint(*args, **kwargs)
    stdout.flush()
