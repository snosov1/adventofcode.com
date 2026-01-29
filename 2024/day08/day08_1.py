from toolz.curried import *
from itertools import product
import sys
import numpy as np

field = pipe(
    sys.stdin.read().splitlines(),
    map(list),
    list
)
n = len(field)
m = len(field[0])

antennas = pipe(
    product(range(n), range(m)),
    map(np.array),
    filter(lambda x: field[x[0]][x[1]] != '.'),
    groupby(lambda x: field[x[0]][x[1]])
)

pipe(
    antennas.values(),
    map(lambda x: filter(lambda y: all(y[0] != y[1]), product(x, x))),
    map(lambda x: pipe(x, map(lambda p: (2 * p[0] - p[1], 2 * p[1] - p[0])))),
    concat,
    concat,
    filter(lambda x: (x >= 0).all() & (x < (n, m)).all()),
    map(lambda x: (x[0], x[1])),
    unique,
    list,
    len,
    print
)
