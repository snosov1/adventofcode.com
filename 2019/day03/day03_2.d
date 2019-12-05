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


    int[Tuple!(int, int)] field;

    foreach (a; [a1, a2])
    {
        int curr = 1;
        auto x = 0;
        auto y = 0;

        auto dict_v = ['R': &x, 'L': &x, 'U': &y, 'D': &y];
        auto dict_s = ['R':  1, 'L': -1, 'U':  1, 'D': -1];

        foreach (p; a)
        {
            auto t = (tuple(x, y) in field);
            if (a is a1)
            {
                if (t is null)
                    field[tuple(x, y)] = curr;
            }
            else
            {
                if (t !is null)
                    *t = -(curr + *t);

            }

            auto v = dict_v[p[0]];
            auto s = dict_s[p[0]];
            auto step = p[1..$].to!int;

            for (int i = 1; i <= step; i++)
            {
                *v = *v + s;

                t = tuple(x, y) in field;
                if (a is a1)
                {
                    if (t is null)
                        field[tuple(x, y)] = curr;
                }
                else
                {
                    if (t !is null)
                        *t = -(curr + *t);
                }

                curr++;

                debug writefln("x = %s, y = %s, field[x, y] = %s", x, y, field.get(tuple(x, y), 0));
            }
        }
    }

    int mind = int.max;
    foreach (i, e; field)
    {
        if (e < 0)
        {
            int d = -e;
            if (d == 2)
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
