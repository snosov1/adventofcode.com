from toolz.curried import *
from itertools import product
import sys
import re
import numpy as np

def det(c0, c1):
    return int(c0[0]) * int(c1[1]) - int(c0[1]) * int(c1[0])

off = 10000000000000

def solve(c0, c1, c2):
    c2 = (int(c2[0]) + off, int(c2[1]) + off)

    d = det(c0, c1)
    a = det(c2, c1)
    b = det(c0, c2)

    return (a // d if a % d == 0 else None, b // d if b % d == 0 else None)

pipe(
    sys.stdin.read().splitlines(),
    partition_all(4),
    map(lambda x: (
        re.search(r'Button A: X\+(\d+), Y\+(\d+)', x[0]).groups(),
        re.search(r'Button B: X\+(\d+), Y\+(\d+)', x[1]).groups(),
        re.search(r'Prize: X=(\d+), Y=(\d+)', x[2]).groups()
    )),
    map(lambda x: solve(*x)),
    filter(lambda x: x[0] != None and x[1] != None),
    map(lambda x: 3 * x[0] + x[1]),
    sum,
    print
)
