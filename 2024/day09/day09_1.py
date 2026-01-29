from toolz.curried import *
from operator import add
import sys

state = pipe(
    sys.stdin.read(),
    partition(2),
    enumerate,
    map(lambda x: ((x[0], int(x[1][0])), (None, int(x[1][1]) if x[1][1] != '\n' else None))),
    concat,
    list
)
state = state[:len(state) - 1]
files = pipe(state, take_nth(2), list)
files = files[len(files)-1::-1]
n = pipe(files, map(get(1)), sum)

new_state = []
i = 0
j = 0
while i < len(state) and j < len(files):
    if state[i][0] != None:
        if state[i][1] > 0:
            new_state.append(state[i])
        i += 1
    elif files[j][1] <= state[i][1]:
        if files[j][1] > 0:
            new_state.append(files[j])
        state[i] = (None, state[i][1] - files[j][1])
        j += 1
    elif files[j][1] > state[i][1]:
        if state[i][1] > 0:
            new_state.append((files[j][0], state[i][1]))
        files[j] = (files[j][0], files[j][1] - state[i][1])
        i += 1

i = 0
while i < len(new_state) - 1:
    if new_state[i][0] == new_state[i+1][0]:
       new_state[i] = (new_state[i][0], new_state[i][1] + new_state[i+1][1])
       i += 1
    i += 1

i = 0
l = 0
while i < len(new_state):
    l += new_state[i][1]
    if l >= n:
        new_state[i] = (new_state[i][0], new_state[i][1] - l + n)
        i += 1
        break
    i += 1

final_state = pipe(
    new_state,
    take(i),
    list
)

pipe(
    final_state,
    map(lambda x: [x[0]] * x[1]),
    concat,
    enumerate,
    map(lambda x: x[0] * x[1]),
    sum,
    print
)
