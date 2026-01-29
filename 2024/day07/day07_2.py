from toolz.curried import *
import sys

def calc(vals, ops):
    v = vals[0]
    for i, r in enumerate(vals[1:]):
        op = ops % 3
        ops //= 3
        if op == 0:
            v += r
        elif op == 1:
            v *= r
        else:
            v = int(str(v) + str(r))
    return v

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: x.split(':')),
    map(lambda x: (int(x[0]), pipe(x[1].split(), map(int), list))),
    filter(lambda x: x[0] in pipe(
        range(3**(len(x[1]) - 1)),
        map(lambda y: calc(x[1], y)),
        list
    )),
    map(lambda x: x[0]),
    sum,
    print
)
