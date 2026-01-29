from toolz.curried import *
import sys

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: x.split(':')),
    map(lambda x: (int(x[0]), pipe(x[1].split(), map(int), list))),
    filter(lambda x: x[0] in pipe(
        range(2**(len(x[1]) - 1)),
        map(lambda y:
            reduce(
                lambda acc, i_r: acc + i_r[1] if y & (1 << i_r[0]) else acc * i_r[1],
                enumerate(x[1][1:]),
                x[1][0]
            )),
        list
    )),
    map(lambda x: x[0]),
    sum,
    print
)
