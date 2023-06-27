import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;

int main(string[] args)
{
    auto cubes = stdin.byLine.map!(line =>
        line.split(",").map!(x => x.to!int).array
        ).array;

    int s = 0;
    foreach (axes; [[0, 1, 2], [0, 2, 1], [1, 2, 0]])
    {
        int[] mins, maxs;
        foreach (a; axes)
        {
            auto as = cubes.map!(x => x[a]);
            mins ~= as.minElement;
            maxs ~= as.maxElement;
        }

        foreach (cp; cartesianProduct(iota(mins[0], maxs[0] + 1), iota(mins[1], maxs[1] + 1)))
        {
            s +=
            cubes.filter!(x => x[axes[0]] == cp[0] && x[axes[1]] == cp[1])
                 .map!(x => x[axes[2]])
                 .array
                 .sort
                 .splitWhen!((a,b)=>b-a>1)
                 .walkLength
                 * 2;
        }
    }

    writeln(s);

    return 0;
}
