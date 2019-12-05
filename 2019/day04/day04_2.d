import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.utf;
import std.typecons;
import std.math;
import std.string;

void main(string[] args)
{
    int a, b;
    stdin.readln.formattedRead!"%s-%s"(a, b);

    int ans = 0;
    for (int i = a; i <= b; i++)
    {
        auto cu = i.to!string.byCodeUnit;

        if (cu.isSorted)
        {
            if (!cu.assumeSorted.groupBy.filter!(x => x.count == 2).empty)
            {
                ans++;
            }
        }
    }

    ans.writeln;
}
