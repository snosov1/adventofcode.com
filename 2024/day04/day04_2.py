from toolz.curried import *
import sys

lines = sys.stdin.read().splitlines()

n = len(lines)
assert(n == len(lines[0]))

ans = 0
for i in range(1, n-1):
    for j in range(1, n-1):
        if lines[i][j] == 'A' and \
           sorted(lines[i - 1][j - 1] + lines[i + 1][j + 1]) == ['M', 'S'] and \
           sorted(lines[i - 1][j + 1] + lines[i + 1][j - 1]) == ['M', 'S']:
            ans += 1

print(ans)
