from toolz.curried import *
from itertools import product
import sys

lines = sys.stdin.read().splitlines()
n = len(lines)
assert(n == len(lines[0]))

pipe(
    product(range(1, n-1), range(1, n-1)),
    filter(lambda x: lines[x[0]][x[1]] == 'A'),
    filter(lambda x: sorted(lines[x[0] - 1][x[1] - 1] + lines[x[0] + 1][x[1] + 1]) == ['M', 'S']),
    filter(lambda x: sorted(lines[x[0] - 1][x[1] + 1] + lines[x[0] + 1][x[1] - 1]) == ['M', 'S']),
    list,
    len,
    print
)
