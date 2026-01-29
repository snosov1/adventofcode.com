from toolz.curried import *
import sys

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: pipe(x.split(), map(int), list)),
    map(lambda x: list(map(lambda i: x[:i] + x[i+1:], range(len(x)))) + [x]),
    map(lambda z: any(
        map(lambda x:
            (sorted(x) == x or sorted(x, reverse=True) == x) and \
            all(pipe(sliding_window(2, x), map(lambda y: 1 <= abs(y[0] - y[1]) <= 3))), z))),
    sum,
    print
)
