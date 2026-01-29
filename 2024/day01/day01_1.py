from toolz.curried import *
import sys

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: x.split()),
    lambda x: zip(*x),
    map(lambda x: sorted(map(int, x))),
    lambda x: zip(*x),
    map(lambda x: abs(x[0] - x[1])),
    sum,
    print
)
