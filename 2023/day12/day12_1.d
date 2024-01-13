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
        auto entry = line.split;
        auto condition = entry.front;
        auto list = entry.back.split(',').map!(x => x.to!int);

        int qm = condition.enumerate.map!(x => (1 << x[0]) * (x[1] == '?')).sum;
        int sm = condition.enumerate.map!(x => (1 << x[0]) * (x[1] == '#')).sum;

        s +=
        iota(1 << condition.length).filter!(i => (i & ~qm) == (sm & ~qm))
                                   .map!(x => iota(condition.length).map!(y => (1 << y) & x ? '#' : '.'))
                                   .map!(x => x.group.filter!(y => y[0] == '#').map!(y => y[1]))
                                   .count!(x => x.equal(list));
    }

    s.writeln;
}
