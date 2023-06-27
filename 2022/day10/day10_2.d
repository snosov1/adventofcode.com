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
        int tick = 0;

        foreach (line; stdin.byLine)
        {
            debug writeln(tick, " ", x);

            if (line == "noop")
            {
                yield(x);
                tick++;
            }
            else
            {
                int s = line[5..$].to!int;
                yield(x);
                yield(x);
                x += s;
                tick += 2;
            }
        }

        debug writeln(tick, " ", x);
    });


    r.enumerate
     .map!(x => (x[1] - 1 <= (x[0] % 40) && (x[0] % 40) <= x[1] + 1) ? '#' : '.' )
     .chunks(40)
     .each!(x => x.writeln);
}


// 17   18   19   20   21   22   23   24
//          tick ntick
//               tick ntick
//     tick      ntick
//          tick      ntick
//               tick      ntick
