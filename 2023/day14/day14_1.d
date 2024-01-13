import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;
import std.regex;

void main(string[] args)
{
    auto field = stdin.byLineCopy.array.transposed;
    auto reg = regex(`(.*?)(^|O|#)(\.+?)O(.*)`);

    int s = 0;
    foreach (line; field)
    {
        auto row = line.to!string;
        while(true)
        {
            auto rep = row.replaceFirst(reg, "$1$2O$3$4");
            if (rep.empty || rep == row)
                break;
            row = rep;
        }

        s += row.enumerate.map!(x => (row.length - x[0]) * (x[1] == 'O')).sum;
    }

    s.writeln;
}
