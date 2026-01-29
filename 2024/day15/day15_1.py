from toolz.curried import *
from itertools import product
import sys
import numpy as np

offsets = {
    '^' : np.array((-1,  0)),
    '>' : np.array(( 0,  1)),
    'v' : np.array(( 1,  0)),
    '<' : np.array(( 0, -1))
}
ol = len(offsets)

field, moves = pipe(
    sys.stdin.read().splitlines(),
    partitionby(lambda x: '#' in x)
)
field = pipe(
    field,
    map(list),
    list
)
moves = list(concat(moves))
n = len(field)
m = len(field[0])

def print_field():
    for i in range(n):
        for j in range(m):
            sys.stdout.write(field[i][j])
        print()

def can_move(pos, off):
    if field[pos[0]][pos[1]] == '.':
        return True
    elif field[pos[0]][pos[1]] == '#':
        return False
    else:
        new_pos = pos + off
        if can_move(new_pos, off):
            field[new_pos[0]][new_pos[1]] = field[pos[0]][pos[1]]
            field[pos[0]][pos[1]] = '.'
            return True
        else:
            return False

pos = pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == '@'),
    next
)

for move in moves:
    off = offsets[move]
    if can_move(pos, off):
        pos += off

# print_field()

pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == 'O'),
    map(lambda x: 100 * x[0] + x[1]),
    sum,
    print
)
