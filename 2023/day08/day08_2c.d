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

    // i don't think this works in the general case, (e.g. i guess, there could
    // be multiple nodes ending in Z within the period, etc.), but it seems to
    // be giving the right answer for my input

    long buildPeriod(string node)
    {
        int[string] path;
        long steps = 0L;

        foreach (i; instructions.cycle)
        {
            if (node[$-1] == 'Z')
                return steps;

            steps++;
            node = nodes[node][i == 'R' ? 1 : 0];
        }

        return steps;
    }

    curr.map!(x => buildPeriod(x))
        .fold!((a, b) => lcm(a, b))(1L).writeln;
}
