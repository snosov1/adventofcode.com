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
    map(lambda x: map(lambda y: ord(y) - ord('0'), x)),
    map(list),
    list
)
n = len(field)
m = len(field[0])

zeros = pipe(
    product(range(n), range(m)),
    map(np.array),
    filter(lambda x: field[x[0]][x[1]] == 0),
    list
)

ans = 0
for z in zeros:
    queue = [z]
    nines = {}

    while len(queue) > 0:
        c = queue.pop(0)
        if field[c[0]][c[1]] == 9:
            nines[(c[0], c[1])] = True
            continue

        queue += pipe(
            offsets,
            map(lambda x: x + c),
            filter(lambda x: (x >= 0).all() & (x < (n, m)).all()),
            filter(lambda x: field[x[0]][x[1]] - field[c[0]][c[1]] == 1),
            list
        )
    ans += len(nines)
print(ans)
