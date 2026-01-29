from toolz.curried import *
from bisect import bisect_left as bl
from bisect import bisect_right as br
import sys

pipe(
    sys.stdin.read().splitlines(),
    map(lambda x: x.split()),
    lambda x: zip(*x),
    map(lambda x: sorted(map(int, x))), list,
    lambda x: map(lambda y: (y, x[1]), x[0]),
    map(lambda x: (br(x[1], x[0]) - bl(x[1], x[0])) * x[0]),
    sum,
    print
)
