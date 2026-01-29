from toolz.curried import *
import sys
import re

pipe(
    sys.stdin.read().replace('\n', ''),
    lambda x: re.sub(r"don't\(\)(.*?)do\(\)", '', x),
    lambda x: re.findall(r'mul\((\d{1,3}),(\d{1,3})\)', x),
    map(lambda x: int(x[0]) * int(x[1])),
    sum,
    print
)
