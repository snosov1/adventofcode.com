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
    auto instructions = stdin.byLineCopy.front;
    stdin.byLineCopy.popFront;

    string[2][string] nodes;
    foreach (line; stdin.byLineCopy)
    {
        string k;
        string[2] n;
        line.formattedRead("%s = (%s, %s)", k, n[0], n[1]);
        nodes[k] = n;
    }

    string[] curr = nodes.keys.filter!(x => x[$-1] == 'A').array;

    // int steps = 0;
    // foreach (i; instructions.cycle)
    // {
    //     debug {
    //         curr.writeln;
    //     }

    //     steps++;
    //     foreach (idx, c; curr.enumerate)
    //     {
    //         curr[idx] = nodes[c][i == 'R' ? 1 : 0];
    //         if (c[$-1] == 'Z')
    //             writeln(c, " ", idx, " ", steps);
    //     }

    //     // if (curr.all!(x => x[$-1] == 'Z'))
    //     //     break;
    // }


    struct period_t
    {
        long s;
        long p;
    }

    period_t buildPeriod(string node)
    {
        int[string] path;
        long steps = 0L;
        period_t period;

        foreach (i; instructions.cycle)
        {
            debug {
                write(node, " ");
            }
            if (node[$-1] == 'Z')
            {
                if (period.s == 0)
                    period.s = steps;
                else
                {
                    period.p = steps - period.s;
                    break;
                }
            }

            steps++;
            node = nodes[node][i == 'R' ? 1 : 0];

            // debug {
            //     writeln(node);
            // }

            // if (node in path)
            // {
            //     period.s = path[node];
            //     period.p = steps - path[node];
            //     break;
            // }
            // else
            // {
            //     path[node] = steps;
            // }
        }

        return period;
    }

    // foreach (c; curr)
    // {
    //     buildPeriod(c).writeln;
    // }

    curr.map!(x => buildPeriod(x).p).fold!((a, b) => lcm(a, b))(1L).writeln;

    // int steps = 0;
    // foreach (i; instructions.cycle)
    // {
    //     debug {
    //         curr.writeln;
    //         periods.writeln;
    //     }

    //     steps++;
    //     foreach (idx, c; curr.enumerate)
    //     {
    //         curr[idx] = nodes[c][i == 'R' ? 1 : 0];
    //         if (curr[idx] == start[idx] && periods[idx] == 0)
    //             periods[idx] = steps;
    //     }

    //     if (periods.all!(x => x != 0))
    //         break;

    //     // if (curr.all!(x => x[$-1] == 'Z'))
    //     //     break;
    // }

    // debug {
    //     curr.writeln;
    // }
    // steps.writeln;
    // periods.writeln;
}
