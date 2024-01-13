import std;

void main(string[] args)
{
    auto field = stdin.byLineCopy
                      .map!(x => x.map!(y => y.to!int - '0').array).array;
    int n = field.length;
    int m = field.front.length;
    auto fm = new int[][](n, m);
    foreach (i; 0..n) foreach (j; 0..m) fm[i][j] = int.max;

    int p = 3;
    field.writeln;

    alias Tuple!(int, int, int, int) state_t;
    int[state_t] dp;
    bool isvalid(state_t s)
    {
        return s[0] >= 0 && s[1] >= 0 && s[0] < n && s[1] < m && s[3] >= 0;
    }

    enum {
        up, down, left, right,
    }
    dp[tuple(0, 1, right, p-1)] = field[0][1];
    dp[tuple(1, 0, down, p-1)]  = field[1][0];
    fm[0][0] = 0;
    fm[0][1] = field[0][1];
    fm[1][0] = field[1][0];


    int[state_t] dp2;
    state_t[] cand;
    cand.length = 4;
    while (!dp.empty)
    {
        writeln("dp = ", dp);
        foreach (row; fm)
            row.writeln;

        foreach (f; dp.keys)
        {
            cand[0] = tuple(f[0] - 1, f[1], up,    f[2] == up    ? f[3] - 1 : p-1);
            cand[1] = tuple(f[0] + 1, f[1], down,  f[2] == down  ? f[3] - 1 : p-1);
            cand[2] = tuple(f[0], f[1] - 1, left,  f[2] == left  ? f[3] - 1 : p-1);
            cand[3] = tuple(f[0], f[1] + 1, right, f[2] == right ? f[3] - 1 : p-1);

            //cand.writeln;

            foreach (c; cand.filter!(x => isvalid(x)))
            {
                int cm = dp[f] + field[c[0]][c[1]];

                //writeln(c, " ", cm, " ", fm[c[0]][c[1]]);

                if (fm[c[0]][c[1]] > cm)
                {
                    dp2.keys.filter!(x => x[0] == c[0] && x[1] == c[1]).each!(x => dp2.remove(x));
                    dp2[c] = cm;
                    fm[c[0]][c[1]] = cm;
                }
            }
        }

        dp.clear;
        dp = dp2.dup;
        dp2.clear;
    }

    fm[n-1][m-1].writeln;
}
