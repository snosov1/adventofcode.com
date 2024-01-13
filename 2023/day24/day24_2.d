import std;

long det3(long[] m)
{
    enforce(m.length == 9);

    return
    m[0] * (m[4] * m[8] - m[5] * m[7]) -
    m[1] * (m[3] * m[8] - m[5] * m[6]) +
    m[2] * (m[3] * m[7] - m[4] * m[6]);
}


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

int main(string[] args)
{
    auto stones = stdin.byLine.map!((x){
        long[6] v;
        x.formattedRead("%d, %d, %d @ %d, %d, %d", &v[0], &v[1], &v[2], &v[3], &v[4], &v[5]);
        return v;
    }).array;

    writeln("var('f s t')");
    writefln("eq1 = (%d)*((%d + f * (%d))*(1-t) + (%d + s * (%d))*t)-(%d)*(%d) == (%d)*((%d + f * (%d))*(1-t) + (%d + s * (%d))*t)-(%d)*(%d)",
    stones[2][4], stones[0][0], stones[0][3], stones[1][0], stones[1][3], stones[2][0], stones[2][4],
    stones[2][3], stones[0][1], stones[0][4], stones[1][1], stones[1][4], stones[2][1], stones[2][3]
        );

    writefln("eq2 = (%d)*((%d + f * (%d))*(1-t) + (%d + s * (%d))*t)-(%d)*(%d) == (%d)*((%d + f * (%d))*(1-t) + (%d + s * (%d))*t)-(%d)*(%d)",
    stones[2][5], stones[0][1], stones[0][4], stones[1][1], stones[1][4], stones[2][1], stones[2][5],
    stones[2][4], stones[0][2], stones[0][5], stones[1][2], stones[1][5], stones[2][2], stones[2][4]
        );

    writeln("solve([eq1, eq2], f, s, t)");

    // f == 1/4111823*(1024201549931087929*r1 - 1031277181375714277)/(r1 - 1)
    // s == 1/4111823*(3142846225656478681*r1 + 42559354146302294)/r1
    // t == r1

    // f == 1/4111823*(1024201549931087929*t - 1031277181375714277)/(t - 1)
    // s == 1/4111823*(3142846225656478681*t + 42559354146302294)/t

    // int n = 8;
    // auto vars = chain(
    //     iota(n).map!(x => "t" ~ (x+1).to!string),
    //     iota(n).map!(x => "q" ~ (x+1).to!string),
    //     iota(3).map!(x => "p" ~ (x+1).to!string),
    //     iota(3).map!(x => "v" ~ (x+1).to!string));

    // stones.filter!(x => x[3..$].any!(y => y == 0)).writeln;

    // writeln(
    //     "var('",
    //     vars.join(" "),
    //     "')"
    //     );

    // foreach (i; 0..n)
    // {
    //     foreach (j; 0..3)
    //     {
    //         writefln("eq%d = %d + t%d * (%d) - p%d - q%d * v%d == 0",
    //                  (i) * 3 + (j+1),
    //                  stones[i][j],
    //                  i + 1,
    //                  stones[i][3 + j],
    //                  j + 1,
    //                  i + 1,
    //                  j + 1);
    //     }
    // }

    // writeln(
    //     "solve([",
    //     iota(n * 3).map!(x => "eq" ~ (x+1).to!string).join(", "),
    //     "], ",
    //     vars.join(", "),
    //     ")"
    //     );

    return 0;
}
