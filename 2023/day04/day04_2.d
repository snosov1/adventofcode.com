import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    auto lines = stdin.byLineCopy.array;
    int[] n;
    n.length = lines.length;
    n[] = 1;

    foreach (i, line; lines.enumerate)
    {
        auto lists = line.find(": ")[2..$].split(" | ");

        auto wn = lists[0].split(" ")
                          .filter!(x => !x.empty)
                          .map!(x => x.to!int)
                          .array.sort;
        auto yn = lists[1].split(" ")
                          .filter!(x => !x.empty)
                          .map!(x => x.to!int)
                          .array.sort;

        int c = setIntersection(wn, yn).count;
        n[i+1..i+1+c] += n[i];
    }

    writeln(n.sum);
}
