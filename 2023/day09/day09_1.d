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
    int[] backs;
    foreach (line; stdin.byLineCopy)
    {
        auto curr = line.split.map!(x => x.to!int).array;
        backs ~= curr.back;

        while (curr.any!(x => x != 0))
        {
            curr = iota(curr.length - 1).map!(x => curr[x+1] - curr[x])
                                        .array;
            backs ~= curr.back;
        }
    }

    backs.sum.writeln;
}
