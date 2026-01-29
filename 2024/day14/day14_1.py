from toolz.curried import *
from itertools import product
from operator import mul
import sys
import re
import numpy as np

steps = 100n = 103
m = 101

# n = 7
# m = 11

def quadrant(x):
    if x[0] < m // 2 and x[1] < n // 2:
        return 2
    elif x[0] > m // 2 and x[1] < n // 2:
        return 1
    elif x[0] < m // 2 and x[1] > n // 2:
        return 3
    elif x[0] > m // 2 and x[1] > n // 2:
        return 4

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: re.search(r'p=([-+]?\d+),([-+]?\d+) v=([-+]?\d+),([-+]?\d+)', x).groups()),
    map(lambda x: tuple(map(int, x))),
    map(lambda x: pipe(x, partition(2), map(np.array), tuple)),
    map(lambda x: x[0] + steps * x[1]),
    map(lambda x: (x[0] % m, x[1] % n)),
    filter(lambda x: x[0] != m // 2 and x[1] != n // 2),
    groupby(quadrant),
    valmap(len),
    lambda x: x.values(),
    reduce(mul),
    print
)
