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

    int s = 0;
    foreach (line; stdin.byLineCopy)
    {
        auto curr = line.split.map!(x => x.to!int).array;
        int[] fronts;
        fronts ~= curr.front;

        while (curr.any!(x => x != 0))
        {
            curr = iota(curr.length - 1).map!(x => curr[x+1] - curr[x])
                                        .array;
            fronts ~= curr.front;
        }

        debug {
            fronts.writeln;
        }
        int k = 0;
        foreach (i; iota(fronts.length))
        {
            k = fronts[$ - i - 1] - k;
            debug {
                k.writeln;
            }
        }

        s += k;
    }

    s.writeln;
}
