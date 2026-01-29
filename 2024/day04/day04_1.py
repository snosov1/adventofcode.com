from toolz.curried import *
import sys

lines = sys.stdin.read().splitlines()
search_list = lines.copy() # W -> E
search_list += [x[::-1] for x in lines] # E -> W

lines_t = [''.join(x) for x in zip(*lines)]
search_list += lines_t # N -> S
search_list += [x[::-1] for x in lines_t] # S -> N

n = len(lines)
assert(n == len(lines[0]))

d = [''.join([lines[j][n - 1 - i + j] for j in range(i + 1)]) for i in range(n)] + \
    [''.join([lines[i + j + 1][j] for j in range(n - 1 - i)]) for i in range(n - 1)]
search_list += d # NW -> SE
search_list += [x[::-1] for x in d] # SE -> NW

d2 = [''.join([lines[i - j][j] for j in range(i + 1)]) for i in range(n)] + \
     [''.join([lines[n - 1 - j][i + j + 1] for j in range(n - 1 - i)]) for i in range(n - 1)]
search_list += d2 # SW -> NE
search_list += [x[::-1] for x in d2] # NE -> SW

print(sum([line.count('XMAS') for line in search_list]))
