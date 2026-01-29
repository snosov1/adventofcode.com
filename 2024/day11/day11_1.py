from toolz.curried import *
from operator import add
import sys

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
    map(int)
)

for i in range(25):
    states = pipe(
        states,
        map(change),
        concat,
        list
    )

print(len(states))
