import std;

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    int n = field.length, m = field.front.length;
    int si = 0, sj = 1;
    auto e = [n-1, m-2];

    enum offs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    enum legal = [
        '>' : [[ 0,  1]],
        'v' : [[ 1,  0]],
        '<' : [[ 0, -1]],
        '^' : [[-1,  0]],
        ];

    int[] ls;
    int fork(int[] d, int[] s)
    {
        int[2] c, cc;
        int[][] queue;
        queue ~= s;
        while (!queue.empty)
        {
            auto curr = queue.front;
            queue.popFront;

            if (curr == e)
            {
                ls ~= d[e[0] * m + e[1]];
                return d[e[0] * m + e[1]];
            }

            auto p = field[curr[0]][curr[1]];
            auto dirs = p in legal ? legal[p] : offs;

            foreach (off; dirs)
            {
                c[] = curr[] + off[];
                if (c[0] >= 0 && c[1] >= 0 && c[0] < n && c[1] < m &&
                    field[c[0]][c[1]] != '#' &&
                    d[c[0] * m + c[1]] < 0)
                {
                    d[c[0] * m + c[1]] = d[curr[0] * m + curr[1]] + 1;
                    if (field[c[0]][c[1]] in legal)
                    {
                        debug {
                            writeln(field[c[0]][c[1]]);
                            foreach (row; d.chunks(m))
                            {
                                foreach (i; row)
                                    writef("%4d", i);
                                writeln;
                            }
                            writeln;
                        }

                        cc[] = c[];
                        c[] += legal[field[c[0]][c[1]]][0][];
                        d[c[0] * m + c[1]] = d[cc[0] * m + cc[1]] + 1;

                        ls ~= fork(d.dup, c.dup);
                    }
                    else
                        queue ~= c.dup;
                }
            }
        }

        return d[e[0] * m + e[1]];
    }

    int[] dist;
    dist.length = n*m;
    dist[] = -1;
    dist[si * m + sj] = 0;

    fork(dist, [si, sj]);

    ls.maxElement.writeln;
}
