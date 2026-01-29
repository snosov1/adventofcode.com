from toolz.curried import *
from operator import add
import sys
from collections import defaultdict

def change(s):
    if s == 0:
        return (1, )
    ss = str(s)
    n = len(ss)
    if n % 2 == 0:
        return (int(ss[:n // 2]), int(ss[n // 2:]))
    return (s * 2024, )

states = pipe(
    sys.stdin.read().split(),
    map(lambda x: (int(x), 1)),
    dict
)

for i in range(75):
    new_states = defaultdict(int)
    for k in states.keys():
        for c in change(k):
            new_states[c] += states[k]
    states = new_states

pipe(
    states.values(),
    sum,
    print
)
