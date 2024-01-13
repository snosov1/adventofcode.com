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

    //zsorted.writeln;
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
                //writeln("qq", i, " ", j);
                z = max(z, z1+1);
            }
        }

        zsorted[i][1][0][2] -= (z0 - z);
        zsorted[i][1][1][2] -= (z0 - z);
    }

    //zsorted.writeln;

    enum eye = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
    int[] p,q,v;
    v.length = q.length = p.length = 3;
    //char[][char] dict;
    int[][int] dict;

    foreach (i; 0..zsorted.length)
    {
        int z = 1;
        auto b0 = zsorted[i][1];
        auto z0 = min(b0[0][2], b0[1][2]);
        foreach (j; 0..zsorted[0..i].length)
        {
            auto b1 = zsorted[j][1];
            auto z1 = max(b1[0][2], b1[1][2]);

            if (intersect2d(b0, b1) && z1 + 1 == z0)
            {
                dict[zsorted[i][0]] ~= zsorted[j][0];

                //dict[(zsorted[i][0] + 'A').to!char] ~= (zsorted[j][0] + 'A').to!char;
                //dict[(zsorted[j][0] + 'A').to!char] ~= (zsorted[i][0] + 'A').to!char;
            }
        }
    }

    int ans = 0;
    foreach (i; 0..zsorted.length)
    {
        if (dict.values
                   .map!(x => x.filter!(y => y != i))
                   .all!(x => !x.empty))
            ans++;
    }

    writeln(ans);
}
