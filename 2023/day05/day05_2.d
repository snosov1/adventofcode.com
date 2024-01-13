import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    auto seeds_entry = stdin.byLineCopy
                            .front.find(": ")[2..$]
                            .split(" ")
                            .map!(x => x.to!long)
                            .array;

    // long[] seeds;
    // auto seeds_app = appender(&seeds);
    // foreach (s; seeds_entry.chunks(2))
    //     seeds_app ~= iota(s[0], s[0] + s[1]);

    stdin.byLineCopy.popFront;
    auto maps = stdin.byLineCopy.array.splitter("")
                     .map!(x => x[1..$])
                     .map!(x => x.map!(y => y.split(" ").to!(long[])))
                     .array;

    foreach (long c; iota(int.max))
    {
        long cc = c;
        foreach (m; maps.retro)
        {
            auto r = m.filter!(x => (cc >= x[0]) && (cc < x[0] + x[2]));

            if (!r.empty)
                cc = cc - r.front[0] + r.front[1];
        }

        if (!seeds_entry.chunks(2).filter!(x => (cc >= x[0]) && (cc < x[0] + x[1])).empty)
        {
            writeln(c);
            return;
        }
    }
}
