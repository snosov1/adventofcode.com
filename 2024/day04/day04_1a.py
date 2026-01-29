from toolz.curried import *
from itertools import product
import sys
import numpy as np

dirs = [np.array(x) for x in [
    (-1, -1), (-1, 0), (-1, 1),
    ( 0, -1),          ( 0, 1),
    ( 1, -1), ( 1, 0), ( 1, 1)
]]
s = 'XMAS'

lines = sys.stdin.read().splitlines()

n = len(lines)
assert(n == len(lines[0]))

pipe(
    product(range(0, n), range(0, n), dirs),
    map(lambda x: [np.array((x[0], x[1])) + x[2] * i for i in range(len(s))]),
    filter(lambda x: all([all((0 <= y) & (y < n)) for y in x])),
    map(lambda x: ''.join([lines[y[0]][y[1]] for y in x])),
    filter(lambda x: x == s),
    list, len,
    print
)
