import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;

void main(string[] args)
{
    string[] universe;

    foreach (line; stdin.byLine)
    {
        universe ~= line.dup;

        // expand vertically
        if (line.all!(x => x == '.'))
            universe ~= line.dup;
    }

    // expand horizontally
    int[] expanding_cols;
    foreach (j; iota(universe.front.length))
    {
        if (iota(universe.length).map!(i => universe[i][j]).all!(x => x == '.'))
            expanding_cols ~= j;
    }

    foreach (c; expanding_cols.retro)
    {
        foreach (i; iota(universe.length))
        {
            universe[i] = universe[i][0..c+1] ~ universe[i][c..$];
        }
    }

    debug {
        universe.join('\n').writeln;
    }

    int n = universe.length, m = universe.front.length;

    auto galaxies = iota(n).cartesianProduct(iota(m)).filter!(x => universe[x[0]][x[1]] == '#').array;

    int ng = galaxies.length;
    iota(ng).cartesianProduct(iota(ng)).filter!(x => x[0] > x[1])
            .map!(x => abs(galaxies[x[0]][0] - galaxies[x[1]][0]) + abs(galaxies[x[0]][1] - galaxies[x[1]][1]))
            .sum
            .writeln;
}
