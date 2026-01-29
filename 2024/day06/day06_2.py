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
orig_pos = pos

def has_loop():
    d = {}
    co = 0
    pos = orig_pos
    while True:
        if (pos[0], pos[1], co) in d:
            return (True, d)
        d[(pos[0], pos[1], co)] = True
        new_pos = (pos[0] + offsets[co][0], pos[1] + offsets[co][1])
        if new_pos[0] < 0 or new_pos[0] >= n or new_pos[1] < 0 or new_pos[1] >= m:
            return (False, d)
        if field[new_pos[0]][new_pos[1]] == '#':
            co = (co + 1) % ol
        else:
            pos = new_pos

opps = pipe(
    has_loop()[1].keys(),
    map(lambda x: (x[0], x[1])),
    unique
)

ans = 0
for opp in opps:
    field[opp[0]][opp[1]] = '#'
    if has_loop()[0]:
        ans += 1
    field[opp[0]][opp[1]] = 'X'

print(ans)
