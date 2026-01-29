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
ns = {
    (-1,  0) : 0,
    ( 0,  1) : 1,
    ( 1,  0) : 2,
    ( 0, -1) : 3
}

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
    edges = []
    for i in range(ol):
        edges.append(np.full((n, m), False))

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

        dirs = pipe(
            neighbors,
            map(lambda x: x - c),
            map(lambda x: ns[(x[0], x[1])]),
            list
        )

        for i in range(ol):
            if not i in dirs:
                edges[i][c[0], c[1]] = True

        s += 1
        queue += neighbors

    # print(l)
    # for i in range(ol):
    #     print(edges[i])

    p = 0
    for e in range(ol):
        for i in range(n if e % 2 == 0 else m):
            p += pipe(
                edges[e][i, :] if e % 2 == 0 else edges[e][:, i],
                partitionby(identity),
                filter(get(0)),
                list,
                len
            )

    return (s, p)

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
