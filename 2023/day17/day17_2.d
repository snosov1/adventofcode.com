import std;

void main(string[] args)
{
    auto field = stdin.byLineCopy
                      .map!(x => x.map!(y => y.to!int - '0').array).array;
    int n = field.length;
    int m = field.front.length;
    enum {
        up, down, left, right,
    }
    int d = 4;
    int p = 10;
    int pm = 4;
    auto fm = new int[][][][](n, m, d, p);
    foreach (i; 0..n)
        foreach (j; 0..m)
            foreach (k; 0..d)
                foreach (l; 0..p)
                    fm[i][j][k][l] = 1_000_000;

    //field.writeln;

    auto reject = [
        up : down,
        left : right,
        down : up,
        right : left
    ];

    // foreach (k; 0..d)
    //     foreach (l; pm..p)
    //         fm[0][0][k][9] = 0;
    fm[0][1][right][p-1] = field[0][1];
    fm[1][0][down][p-1]  = field[1][0];

    alias Tuple!(int, int, int, int) state_t;
    state_t[] cand;
    bool isvalid(state_t s)
    {
        return s[0] >= 0 && s[1] >= 0 && s[0] < n && s[1] < m && s[3] >= 0;
    }

    // still hate this 100
    foreach (T; 0..100)
    {
        foreach (i; 0..n)
            foreach (j; 0..m)
                foreach (k; 0..d)
                    foreach (l; 0..p)
                    {
                        debug {
                            // if (k == 0 && l == 0)
                            // {
                            //     writeln(i, " ", j, " ", k, " ", l);
                            //     foreach (ii; 0..n)
                            //     {
                            //         foreach (jj; 0..m)
                            //         {
                            //             auto w = iota(d).cartesianProduct(iota(p))
                            //                             .map!(x => fm[ii][jj][x[0]][x[1]])
                            //                             .minElement;

                            //             if (w == 1_000_000)
                            //                 write("   *");
                            //             else
                            //                 writef("%4d", w);
                            //         }
                            //         writeln;
                            //     }
                            // }
                        }

                        if (l > p - pm)
                        {
                            cand.length = 1;
                            int oi, oj;
                            if (k == up)    oi = -1;
                            if (k == down)  oi =  1;
                            if (k == left)  oj = -1;
                            if (k == right) oj =  1;

                            cand[0] = tuple(i + oi, j + oj, k, l - 1);
                        }
                        else
                        {
                            cand.length = 4;
                            cand[up]    = tuple(i - 1, j, up,    k == up    ? l - 1 : p-1);
                            cand[down]  = tuple(i + 1, j, down,  k == down  ? l - 1 : p-1);
                            cand[left]  = tuple(i, j - 1, left,  k == left  ? l - 1 : p-1);
                            cand[right] = tuple(i, j + 1, right, k == right ? l - 1 : p-1);
                            cand = cand.remove(reject[k]);
                        }

                        foreach (c; cand.filter!(x => isvalid(x)))
                        {
                            int cm = fm[i][j][k][l] + field[c[0]][c[1]];

                            fm[c[0]][c[1]][c[2]][c[3]] = min(fm[c[0]][c[1]][c[2]][c[3]], cm);
                        }
                    }


        debug {
            foreach (ii; 0..n)
            {
                foreach (jj; 0..m)
                {
                    auto w = iota(d).cartesianProduct(iota(0, p-pm+1))
                                    .map!(x => fm[ii][jj][x[0]][x[1]])
                                    .minElement;

                    if (w == 1_000_000)
                        write("   *");
                    else
                        writef("%4d", w);
                }
                writeln;
            }
        }

    }

    int ans = 10_000;
    foreach (k; 0..d)
        foreach (l; 0..p-pm+1)
            ans = min(ans, fm[n-1][m-1][k][l]);

    ans.writeln;
}
