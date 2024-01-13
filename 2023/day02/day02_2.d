import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    int s = 0;
    foreach (line; stdin.byLine)
    {
        auto limits = [
            "red" : 0,
            "green": 0,
            "blue": 0
            ];

        foreach (round; line.find(": ")[2..$].split("; "))
        {
            foreach (ball; round.split(", "))
            {
                auto n = ball.split(" ");
                limits[n[1].to!string] = max(limits[n[1]], n[0].to!int);
            }
        }

        s += limits.values.fold!((a, b) => a * b)(1);
    }

    writeln(s);

}
