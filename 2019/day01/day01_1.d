import std.stdio;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args)
{
    stdin.byLine.map!(x => x.to!int / 3 - 2).reduce!((a, b) => a + b).writeln;
}
