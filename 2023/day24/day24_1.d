import std;

int solve2(long[] m, float[] res)
{
    enforce(m.length == 6);

    long d = m[0] * m[4] - m[1] * m[3];

    if (d == 0)
    {
        return 0;
    }

    res[0] = (m[2] * m[4] - m[1] * m[5]) / cast(float)d;
    res[1] = (m[0] * m[5] - m[2] * m[3]) / cast(float)d;

    return 1;
}

// int solve(long[] mat)
// {
//     assert(mat.length == 9);

//     long[3] buf;
//     long[] m = mat.dup;

//     auto l = iota(0, 7, 3).find!(i => m[i] != 0);
//     if (l.empty)
//     {
//         if (m[1] * m[5] == m[2] * m[4] && m[4] * m[8] == m[5] * m[7])
//             return 0; // infinite many solutions

//         return -1; // no solution
//     }
//     writeln(l);

//     return 0;
//     // m[0..3] *= mat[4];
//     // m[4..7] *= mat[0];
//     // m[4..7] -= m[0..3];
// }

int main(string[] args)
{
    // long[] mat = [0, 2, 3, 4, 5, 6, 7, 8, 9];

    // solve(mat);

    auto stones = stdin.byLine.map!((x){
        long[6] v;
        x.formattedRead("%d, %d, %d @ %d, %d, %d", &v[0], &v[1], &v[2], &v[3], &v[4], &v[5]);
        return v;
    }).array;

    long[6] mat;
    float[2] res;

    // long l = 7;
    // long r = 27;

    long l = 200000000000000;
    long r = 400000000000000;

    int ans = 0;
    foreach (i; 0..stones.length)
    {
        foreach (j; i+1..stones.length)
        {
            mat[0] = stones[i][3];
            mat[1] = stones[j][3];
            mat[2] = stones[j][0] - stones[i][0];

            mat[3] = stones[i][4];
            mat[4] = stones[j][4];
            mat[5] = stones[j][1] - stones[i][1];

            if (solve2(mat, res) > 0)
            {
                if (res[0] > 0 && res[1] < 0 &&
                    iota(2).map!(x => stones[i][0 + x] + res[0] * stones[i][3 + x])
                           .all!(x => x >= l && x <= r))
                    ans++;
            }
        }
    }

    // stones.writeln;

    ans.writeln;

    return 0;
}
