import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{

    auto r = new Generator!int({
        int x = 1;
        int tick = 1;

        foreach (line; stdin.byLine.chain(["noop"]))
        {
            debug writeln(tick, " ", x);

            if ((tick - 20) % 40 == 0)
            {
                debug writeln("yielding ", x * tick);
                yield(x * tick);
            }

            if (line == "noop")
            {
                tick++;
            }
            else
            {
                int s = line[5..$].to!int;
                if (tick == 19 || (tick - 20) % 40 == 39)
                {
                    debug writeln("yielding ", x * (tick + 1));
                    yield(x * (tick + 1));
                }
                x += s;
                tick += 2;
            }
        }

        debug writeln(tick, " ", x);
    });

    writeln(r.sum);
}


// 17   18   19   20   21   22   23   24
//          tick ntick
//               tick ntick
//     tick      ntick
//          tick      ntick
//               tick      ntick
