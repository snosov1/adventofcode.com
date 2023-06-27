import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;

void main(string[] args)
{
    auto input = stdin.byLineCopy.array;

    auto xs = input.join(" -> ").splitter(" -> ")
                   .map!(x => x.splitter(",").front.to!int);

    auto minx = xs.minElement;
    auto maxx = xs.maxElement;

    auto miny = 0;
    auto maxy = input.join(" -> ").splitter(" -> ")
                     .map!(x => x.find(",")[1..$].to!int).maxElement;

    auto orig = maxx - minx;
    minx -= orig * 4; // * 4 is a heuristic. I think, maybe, a triangle number-based estimate could be done
    maxx += orig * 4;
    maxy += 2;
    input ~= "%d,%d -> %d,%d".format(minx, maxy, maxx, maxy);

    // writeln(minx, " ", maxx);
    // writeln(maxy); // test = 9, in = 168

    auto N = maxx - minx + 1, M = maxy - miny + 1;
    int[] field;
    field.length = N*M;

    foreach (line; input)
    {
        foreach (start, end; lockstep(
            line.splitter(" -> "),
            line.splitter(" -> ").drop(1)))
        {
            auto sr = start.splitter(",");
            auto sx = sr.front.to!int - minx;
            sr.popFront;
            auto sy = sr.front.to!int - miny;

            auto er = end.splitter(",");
            auto ex = er.front.to!int - minx;
            er.popFront;
            auto ey = er.front.to!int - miny;

            auto off = [ex, ey];
            off[] -= [sx, sy];
            enforce(off[0] == 0 || off[1] == 0);
            off[0] = off[0].sgn;
            off[1] = off[1].sgn;

            auto s = [sx, sy];
            auto e = [ex, ey];
            e[] += off[];
            while(s != e)
            {
                field[s[1] * N + s[0]] = 1;
                s[] += off[];
            }
        }
    }

    auto init = [500 - minx, 0 - miny];
    foreach (i; sequence!((a,n) => n)())
    {
        auto curr = init.dup;
        while (true)
        {
            auto cand = curr.repeat(3).zip([[0, 1], [-1, 1], [1, 1]])
                            .map!(x => [x[0][0] + x[1][0], x[0][1] + x[1][1]]);

            if (cand.canFind!(x => x[1] * N + x[0] < 0 || x[1] * N + x[0] >= N*M))
            {
                writeln("in abyss at ", i);
                return;
            }

            auto next = cand.find!(x => field[x[1] * N + x[0]] == 0);

            if (next.empty)
            {
                field[curr[1] * N + curr[0]] = 2;
                if (curr == init)
                {
                    writeln("stuck at ", i+1);
                    return;
                }
                break;
            }
            else
            {
                curr = next.front;
            }
        }

        debug writeln("qq");
        debug field.chunks(N).each!(x => x.writeln);
    }
}
