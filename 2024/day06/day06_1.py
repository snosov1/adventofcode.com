from toolz.curried import *
from itertools import product
import sys

offsets = [
    (-1,  0),
    ( 0,  1),
    ( 1,  0),
    ( 0, -1)
]
ol = len(offsets)

field = pipe(
    sys.stdin.read().splitlines(),
    map(list),
    list
)
n = len(field)
m = len(field[0])

pos = pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == '^'),
    next
)
co = 0

while True:
    field[pos[0]][pos[1]] = 'X'
    new_pos = (pos[0] + offsets[co][0], pos[1] + offsets[co][1])
    if new_pos[0] < 0 or new_pos[0] >= n or new_pos[1] < 0 or new_pos[1] >= m:
        break
    if field[new_pos[0]][new_pos[1]] == '#':
        co = (co + 1) % ol
    else:
        pos = new_pos

pipe(
    field,
    map(lambda x: x.count('X')),
    sum,
    print
)
