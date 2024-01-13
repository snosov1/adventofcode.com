import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    auto seeds = stdin.byLineCopy
                      .front.find(": ")[2..$]
                      .split(" ")
                      .map!(x => x.to!long)
                      .array;

    stdin.byLineCopy.popFront;
    foreach (m; stdin.byLineCopy.array.splitter(""))
    {
        foreach (ref s; seeds)
        {
            auto r = m[1..$].map!(x => x.split(" ").to!(long[]))
                            .filter!(x => (s >= x[1]) && (s < x[1] + x[2]));

            if (!r.empty)
                s = s - r.front[1] + r.front[0];
        }
    }

    writeln(seeds.minElement);
}
