import std;

bool intersect2d(int[][] a, int[][] b)
{
    if (max(a[0][0], a[1][0]) < min(b[0][0], b[1][0]) || min(a[0][0], a[1][0]) > max(b[0][0], b[1][0]))
        return false;

    if (max(a[0][1], a[1][1]) < min(b[0][1], b[1][1]) || min(a[0][1], a[1][1]) > max(b[0][1], b[1][1]))
        return false;

    return true;
}


void main(string[] args)
{
    auto bricks = stdin.byLineCopy.map!(x => x.split("~").map!(y => y.split(",").map!(to!int).array).array).array.enumerate.array;

    auto zsorted = bricks.dup;
    zsorted.sort!((a, b) => min(a[1][0][2], a[1][1][2]) < min(b[1][0][2], b[1][1][2]));

    foreach (i; 0..zsorted.length)
    {
        int z = 1;
        auto b0 = zsorted[i][1];
        auto z0 = min(b0[0][2], b0[1][2]);
        foreach (j; 0..zsorted[0..i].length)
        {
            auto b1 = zsorted[j][1];
            auto z1 = max(b1[0][2], b1[1][2]);

            if (intersect2d(b0, b1) && z1 < z0)
            {
                z = max(z, z1+1);
            }
        }

        zsorted[i][1][0][2] -= (z0 - z);
        zsorted[i][1][1][2] -= (z0 - z);
    }

    //char[][char] dict;
    int[] ans;
    ans.length = zsorted.length;

    foreach (d; 0..zsorted.length)
    {
        auto zsorted_dup = zsorted.filter!(x => x[0] != d).map!(x => x[1])
                                  .map!(x => x.map!(y => y.dup).array).array.enumerate;
               //.writeln;

        foreach (i; 0..zsorted_dup.length)
        {
            int z = 1;
            auto b0 = zsorted_dup[i][1];
            auto z0 = min(b0[0][2], b0[1][2]);
            foreach (j; 0..zsorted_dup[0..i].length)
            {
                auto b1 = zsorted_dup[j][1];
                auto z1 = max(b1[0][2], b1[1][2]);

                if (intersect2d(b0, b1) && z1 < z0)
                {
                    z = max(z, z1+1);
                }
            }

            zsorted_dup[i][1][0][2] -= (z0 - z);
            zsorted_dup[i][1][1][2] -= (z0 - z);

            if (z0 - z > 0)
                ans[d]++;
        }
    }

    writeln(ans.sum);
}
