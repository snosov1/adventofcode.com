import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;

long ABS(long x)
{
    if (x < 0)
        x = -x;
    return x;
}

void main(string[] args)
{
    string[] universe;
    int[] expanding_rows, expanding_cols;
    foreach (i, line; stdin.byLine.enumerate)
    {
        universe ~= line.dup;

        if (line.all!(x => x == '.'))
            expanding_rows ~= i;
    }

    foreach (j; iota(universe.front.length))
    {
        if (iota(universe.length).map!(i => universe[i][j]).all!(x => x == '.'))
            expanding_cols ~= j;
    }

    debug {
        universe.join('\n').writeln;
    }

    debug {
        expanding_rows.writeln;
        expanding_cols.writeln;
    }
    long n = universe.length, m = universe.front.length;

    auto galaxies = iota(n).cartesianProduct(iota(m)).filter!(x => universe[x[0].to!int][x[1].to!int] == '#').array;
    int ng = galaxies.length;
    long e = 1_000_000L;

    foreach (ref g; galaxies)
    {
        g[0] += expanding_rows.filter!(x => x < g[0]).walkLength * (e - 1);
        g[1] += expanding_cols.filter!(x => x < g[1]).walkLength * (e - 1);
    }

    iota(ng).cartesianProduct(iota(ng)).filter!(x => x[0] > x[1])
            .map!(x => abs(galaxies[x[0]][0] - galaxies[x[1]][0]) + abs(galaxies[x[0]][1] - galaxies[x[1]][1]))
            .sum
            .writeln;
}
