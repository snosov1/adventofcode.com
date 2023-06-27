import std.stdio;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args)
{
    auto d = [
        "A X" : 1 + 3,
        "A Y" : 2 + 6,
        "A Z" : 3 + 0,

        "B X" : 1 + 0,
        "B Y" : 2 + 3,
        "B Z" : 3 + 6,

        "C X" : 1 + 6,
        "C Y" : 2 + 0,
        "C Z" : 3 + 3,

        ];

    stdin.byLine.map!(x => d[x]).sum.writeln;
}
