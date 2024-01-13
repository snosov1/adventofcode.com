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
    foreach (field; stdin.byLineCopy.array.splitter(""))
    {
        int n = field.length;
        int m = field.front.length;

        // vertical lines
        s +=
        iota(m-1).map!(i => zip(iota(i+1).retro.map!(j => field.map!(x => x[j])), iota(i+1, m).map!(j => field.map!(x => x[j]))))
                 .enumerate
                 .filter!(x => x[1].all!(y => y[0].equal(y[1])))
                 .map!(x => x[0] + 1)
                 .sum;

        // horizontal lines
        s +=
        iota(n-1).map!(i => zip(field[0..i+1].retro, field[i+1..$]))
                 .enumerate
                 .filter!(x => x[1].all!(y => y[0].equal(y[1])))
                 .map!(x => 100*(x[0] + 1))
                 .sum;
    }

    s.writeln;
}
