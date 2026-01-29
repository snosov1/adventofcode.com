from toolz.curried import *
from operator import add
import sys
from tqdm import tqdm

state = pipe(
    sys.stdin.read(),
    partition(2),
    enumerate,
    map(lambda x: ((x[0], int(x[1][0])), (None, int(x[1][1]) if x[1][1] != '\n' else None))),
    concat,
    list
)
state = state[:len(state) - 1]

#print()
# print(state)
# print(list())

for idx in range(len(state) // 2, -1, -1):
    curr = pipe(state, map(get(0)), list, lambda l: l.index(idx))
    i = 0
    pos = 0
    is_moved = False
    while i < len(state) and not is_moved:
        if state[i][0] == None and state[i][1] >= state[curr][1] and i < curr:
            if state[i][1] > state[curr][1]:
                state.insert(i+1, (None, state[i][1] - state[curr][1]))
                curr += 1
            state[i] = (state[curr][0], state[curr][1])
            state[curr] = (None, state[curr][1])
            is_moved = True
        i += 1

    j = 0
    while j < len(state):
        while state[j][0] == None and j < len(state) - 1 and state[j+1][0] == None:
            state[j] = (None, state[j][1] + state[j+1][1])
            state.pop(j+1)
            curr -= 1
        j += 1

state = pipe(
    state,
    map(lambda x: (0, x[1]) if x[0] == None else x),
    list
)

pipe(
    state,
    map(lambda x: [x[0]] * x[1]),
    concat,
    enumerate,
    map(lambda x: x[0] * x[1]),
    sum,
    print
)
