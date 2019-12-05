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
    auto a1 = stdin.readln.strip.split(",");
    auto a2 = stdin.readln.strip.split(",");

    debug
    {
        a1.writeln;
        a2.writeln;
    }
    int curr = 0;

    int[Tuple!(int, int)] field;

    foreach (a; [a1, a2])
    {
        curr++;

        auto x = 0;
        auto y = 0;

        auto dict_v = ['R': &x, 'L': &x, 'U': &y, 'D': &y];
        auto dict_s = ['R':  1, 'L': -1, 'U':  1, 'D': -1];

        foreach (p; a)
        {
            auto t = (tuple(x, y) in field);
            if (t !is null && *t != curr)
                field[tuple(x, y)] = 3;
            else
                field[tuple(x, y)] = curr;

            auto v = dict_v[p[0]];
            auto s = dict_s[p[0]];
            auto step = p[1..$].to!int;

            for (int i = 1; i <= step; i++)
            {
                *v = *v + s;

                t = (tuple(x, y) in field);
                if (t !is null && *t != curr)
                    field[tuple(x, y)] = 3;
                else
                    field[tuple(x, y)] = curr;

                debug writefln("x = %s, y = %s, field[x, y] = %s", x, y, field[tuple(x, y)]);
            }
        }
    }

    int mind = int.max;
    foreach (i, e; field)
    {
        if (e == 3)
        {
            int d = abs(i[0]) + abs(i[1]);
            if (d == 0)
                continue;
            if (d < mind)
                mind = d;
        }
    }

    writeln(mind);

    // debug {
    //     for (int i = 0; i < 10; i++)
    //     {
    //         field[i][0..10].writeln;
    //     }
    // }

}
