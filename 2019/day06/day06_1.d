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
        string o1, o2;
        line.formattedRead!"%s)%s"(o1, o2);
        auto p = o1 in inc;

        if (p)
            *p ~= o2;
        else
            inc[o1] = [o2];
    }

    string[] queue;
    queue ~= "COM";
    int[string] orbits;
    orbits[queue.front] = 0;

    while (queue.length > 0)
    {
        string curr = queue.front;
        queue.popFront;
        int dist = orbits[curr];

        foreach (o; inc.get(curr, []))
        {
            orbits[o] = dist + 1;
            queue ~= o;
        }
    }

    orbits.byValue.sum.writeln;
}
