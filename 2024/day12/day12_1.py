from toolz.curried import *
from itertools import product
import sys
import numpy as np

offsets = [
    np.array((-1,  0)),
    np.array(( 0,  1)),
    np.array(( 1,  0)),
    np.array(( 0, -1))
]
ol = len(offsets)

field = pipe(
    sys.stdin.read().splitlines(),
    list
)
n = len(field)
m = len(field[0])

was = np.full((n, m), False)

def bfs(pos):
    queue = [pos]
    l = field[pos[0]][pos[1]]
    s, p = 0, 0

    while len(queue) > 0:
        c = queue.pop(0)
        if was[c[0]][c[1]]:
            continue
        was[c[0]][c[1]] = True

        neighbors = pipe(
            offsets,
            map(lambda x: x + c),
            filter(lambda x: (x >= 0).all() & (x < (n, m)).all()),
            filter(lambda x: field[x[0]][x[1]] == l),
            list
        )
        s += 1
        p += len(neighbors)
        queue += neighbors
    return (s, 4 * s - p)

pipe(
    product(range(n), range(m)),
    filter(lambda x: not was[x[0]][x[1]]),
    map(lambda x: np.array(x)),
    map(bfs),
    list,
    map(lambda x: x[0] * x[1]),
    sum,
    print
)
