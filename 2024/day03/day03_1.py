from toolz.curried import *
import sys
import re

pipe(
    re.findall(r'mul\((\d{1,3}),(\d{1,3})\)', sys.stdin.read()),
    map(lambda x: int(x[0]) * int(x[1])),
    sum,
    print
)
