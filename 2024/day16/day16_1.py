from toolz.curried import *
from itertools import product
import sys
import numpy as np
from numpy import array as v
import igraph as ig
from bidict import bidict

cw = {
    (-1,  0) : ( 0,  1),
    ( 0,  1) : ( 1,  0),
    ( 1,  0) : ( 0, -1),
    ( 0, -1) : (-1,  0)
}
ccw = {
    (-1,  0) : ( 0, -1),
    ( 0,  1) : (-1,  0),
    ( 1,  0) : ( 0,  1),
    ( 0, -1) : ( 1,  0)
}

field = pipe(
    sys.stdin.read().splitlines()
)
field = pipe(
    field,
    map(list),
    list
)
n = len(field)
m = len(field[0])

def print_field():
    for i in range(n):
        for j in range(m):
            sys.stdout.write(field[i][j])
        print()

print_field()

S = pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == 'S'),
    next
)

E = pipe(
    product(range(n), range(m)),
    filter(lambda x: field[x[0]][x[1]] == 'E'),
    next
)

field[S[0]][S[1]] = '.'
field[E[0]][E[1]] = '.'

pos = S
d = (0, 1)
vertices = bidict()
vertices[(pos, d)] = 0
g = ig.Graph()
#g.to_directed(mode="acyclic")
g.add_vertex()
queue = [(pos, d)]
while len(queue) > 0:
    pos, d = queue.pop(0)

    # 1. walk till next vertex
    steps = 0
    while True:
        new_pos = v(pos) + v(d)
        steps += 1
        if field[new_pos[0]][new_pos[1]] == '#':
            break
        if pcw == '#' and pccw == '#':
            continue

        if pcw != '#':
            vert = g.vcount()
            if (pcw, d) in vertices:
                vert = vertices[(pcw, d)]
            else:
                g.add_vertex()
            g.add_edge(pos_vert, vert, weight=steps)
            queue.append((new_pos, d))





#print(S, E)
