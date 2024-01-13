import std;

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    int n = field.length, m = field.front.length;

    int si = n - field.find!(x => x.canFind("S")).length;
    int sj = m - field[si].find("S").length;
    auto s = [si, sj];

    int[] dist;
    dist.length = n*m;
    dist[si * m + sj] = 1;

    int[2] c, curr;
    int[] ndist;
    ndist.length = dist.length;
    enum offs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    foreach (T; 0..64)
    {
        debug {
            foreach (row; dist.chunks(m))
                row.writeln;
        }

        ndist[] = 0;
        foreach (i; 0..n)
        {
            foreach (j; 0..m)
            {
                if (dist[i * m + j] != 0)
                {
                    foreach (off; offs)
                    {
                        c[0] = off[0] + i;
                        c[1] = off[1] + j;
                        if (c[0] >= 0 && c[1] >= 0 && c[0] < n && c[1] < m &&
                            field[c[0]][c[1]] != '#')
                        {
                            ndist[c[0] * m + c[1]] = 1;
                        }
                    }
                }
            }
        }

        dist[] = ndist[];
    }

    debug {
        foreach (row; dist.chunks(m))
            row.writeln;
    }

    dist.count(1).writeln;
}
