import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.string;

void main(string[] args)
{
    string[][string] inc;
    foreach (line; stdin.byLine)
    {
        string[] o = ["", ""];
        line.formattedRead!"%s)%s"(o[0], o[1]);

        foreach (i; [0, 1])
        {
            auto p = o[i] in inc;

            if (p)
                *p ~= o[!i];
            else
                inc[o[i]] = [o[!i]];
        }
    }

    string[] queue;
    queue ~= "YOU";
    int[string] orbits;
    orbits[queue.front] = 0;

    while (queue.length > 0)
    {
        string curr = queue.front;
        queue.popFront;
        int dist = orbits[curr];

        foreach (o; inc.get(curr, []))
        {
            if (o !in orbits)
            {
                orbits[o] = dist + 1;
                queue ~= o;
            }
        }
    }

    writeln(orbits["SAN"] - 2);
}
