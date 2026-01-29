from toolz.curried import *
from itertools import product
from operator import mul
import sys
import re
import numpy as np
from tqdm import tqdm

steps = 100
n = 103
m = 101

# n = 7
# m = 11


bots = pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: re.search(r'p=([-+]?\d+),([-+]?\d+) v=([-+]?\d+),([-+]?\d+)', x).groups()),
    map(lambda x: tuple(map(int, x))),
    map(lambda x: pipe(x, partition(2), map(np.array), tuple)),
    list
)


# so, the solution went like this:
# 1. just print every iteration
# 2. iteration 66 looked suspicious (all bots were concentrated in a relatively narrow vertical strip)
# 3. iteration 66 + 101 looked similarly suspicious
# 4. printed every iteration in range(66, 1000000, 101) and eventually saw a tree on iteration 28144
# 5. now I knew how the tree should look like - a lot of bots are adjacent to one another in a row
# 6. after that, just iterated in range(28145) to find when there's the same number (32) of bots in a row -> 7338

#for steps in range(2026):
#for steps in tqdm(range(66, 1000000, 101)):
#for steps in [28144]:
for steps in range(28145):
    new_bots = pipe(
        bots,
        map(lambda x: x[0] + steps * x[1]),
        map(lambda x: (x[0] % m, x[1] % n)),
        list
    )

    nseq = pipe(
        sorted(new_bots, key=lambda x: (x[1], x[0])),
        map(lambda x: x[0]),
        sliding_window(2),
        partitionby(lambda x: x[1] - x[0] > 1),
        map(len),
        max
    )

    if nseq == 32:
        print(steps)
        for y in range(n):
            for x in range(m):
                sys.stdout.write('#' if (x, y) in new_bots else '.')
            print()
