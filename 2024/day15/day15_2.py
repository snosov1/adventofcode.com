from toolz.curried import *
from itertools import product
import sys
import numpy as np
import os
import time
import keyboard
import copy
from tqdm import tqdm


offsets = {
    '^' : np.array((-1,  0)),
    '>' : np.array(( 0,  1)),
    'v' : np.array(( 1,  0)),
    '<' : np.array(( 0, -1))
}
ol = len(offsets)
dirs = {
     (-1,  0) : '^',
     ( 0,  1) : '>',
     ( 1,  0) : 'v',
     ( 0, -1) : '<'
}

extension = {
    '#' : '##',
    '.' : '..',
    'O' : '[]',
    '@' : '@.'
}

field, moves = pipe(
    sys.stdin.read().splitlines(),
    partitionby(lambda x: '#' in x)
)
field = pipe(
    field,
    map(list),
    map(lambda x: pipe(x, map(lambda y: extension[y]), list)),
    map(lambda x: list(concat(x))),
    list
)
moves = list(concat(moves))
n = len(field)
m = len(field[0])

def print_field(move = None):
    if move is None:
        move = '@'
    #os.system('cls' if os.name == 'nt' else 'clear')
    for i in range(n):
        line = ''.join(field[i][j] if field[i][j] != '@' else move for j in range(m))
        print(line)

# print_field()

stack = []
def can_move(pos, off):
    # this restoration mechanic is bullshit, but I don't care enough
    global field
    save_field = copy.deepcopy(field)
    ret = None

    if field[pos[0]][pos[1]] == '.':
        ret = True
    elif field[pos[0]][pos[1]] == '#':
        ret = False
    elif field[pos[0]][pos[1]] == '[' or field[pos[0]][pos[1]] == ']':
        d = dirs[tuple(off)]
        if d == '<' or d == '>':
            new_pos = pos + off
            if can_move(new_pos, off):
                field[new_pos[0]][new_pos[1]] = field[pos[0]][pos[1]]
                field[pos[0]][pos[1]] = '.'
                ret = True
            else:
                ret = False
        else:
            pos0 = pos
            new_pos0 = pos0 + off

            pos1 = pos + offsets['>' if field[pos[0]][pos[1]] == '[' else '<']
            new_pos1 = pos1 + off
            if can_move(new_pos0, off) and can_move(new_pos1, off):
                field[new_pos0[0]][new_pos0[1]] = field[pos0[0]][pos0[1]]
                field[new_pos1[0]][new_pos1[1]] = field[pos1[0]][pos1[1]]
                field[pos0[0]][pos0[1]] = '.'
                field[pos1[0]][pos1[1]] = '.'
                ret = True
            else:
                ret = False
    elif field[pos[0]][pos[1]] == '@':
        new_pos = pos + off
        if can_move(new_pos, off):
            field[new_pos[0]][new_pos[1]] = '@'
            field[pos[0]][pos[1]] = '.'
            ret = True
        else:
            ret = False
    else:
        assert(False)

    assert(not ret is None)

    if not ret:
        field = save_field
    return ret

pos = pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == '@'),
    next
)

# print_field()

for move in moves:
    #print_field(move)
    off = offsets[move]
    if can_move(pos, off):
        pos += off
    #keyboard.wait('enter')

# print_field()
# print(''.join(moves))

pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == '['),
    map(lambda x: 100 * x[0] + x[1]),
    sum,
    print
)
