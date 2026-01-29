from toolz.curried import *
import sys

edges, pages = pipe(
    sys.stdin.read().splitlines(),
    partitionby(lambda x: '|' in x)
)

edges = list(map(lambda x: pipe(x.split('|'), map(int), tuple), edges))
order = {}
for e in edges:
    order[e[0]] = []
    order[e[1]] = []
for e in edges:
    order[e[0]].append(e[1])

for v in order:
    v = sorted(order[v])

pages = pipe(
    pages[1:],
    map(lambda x: pipe(x.split(','), map(int), tuple)),
    list
)

pipe(
    pages,
    map(lambda x: tuple(sliding_window(2, x))),
    filter(lambda x: all(map(lambda y: y[1] in order[y[0]], x))),
    map(lambda x: x[len(x) // 2][0]),
    sum,
    print
)
