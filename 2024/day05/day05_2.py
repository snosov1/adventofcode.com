from toolz.curried import *
import sys
import numpy as np

def canFind(l, v):
    from bisect import bisect_left as bl
    i = bl(l, v)
    return i < len(l) and l[i] == v

edges, pages = pipe(
    sys.stdin.read().splitlines(),
    partitionby(lambda x: '|' in x)
)

edges = list(map(lambda x: pipe(x.split('|'), map(int), list), edges))
order = {}
for e in edges:
    order[e[0]] = []
    order[e[1]] = []
for e in edges:
    order[e[0]].append(e[1])

for v in order:    v = sorted(order[v])

pages = pipe(
    pages[1:],
    map(lambda x: pipe(x.split(','), map(int), list)),
    list
)

pages = pipe(
    pages,
    map(lambda x: list(sliding_window(2, x))),
    filter(lambda x: any(map(lambda y: y[1] not in order[y[0]], x))),
    list
)

for pairs in pages:
    while any(map(lambda y: y[1] not in order[y[0]], pairs)):
        for i in range(len(pairs)):
            if pairs[i][1] not in order[pairs[i][0]]:
                pairs[i] = (pairs[i][1], pairs[i][0])
                if i < len(pairs) - 1:
                    pairs[i+1] = (pairs[i][1], pairs[i+1][1])
                if i > 0:
                    pairs[i-1] = (pairs[i-1][0], pairs[i][0])

pipe(
    pages,
    map(lambda x: x[len(x) // 2][0]),
    sum,
    print
)
