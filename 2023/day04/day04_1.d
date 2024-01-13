import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    int s = 0;
    foreach (line; stdin.byLine)
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

        auto c = setIntersection(wn, yn).count;
        if (c > 0)
            s += 1 << (c - 1);
    }

    writeln(s);
}
