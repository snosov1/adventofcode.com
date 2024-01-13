import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    stdin.byLine
         .map!(x => x.find(": ")[2..$].split(" | "))
         .map!(x => x.map!(y => y.split(" ")
                                 .filter!(x => !x.empty)
                                 .map!(x => x.to!int)
                                 .array.sort))
         .map!(x => setIntersection(x[0], x[1]).count)
         .filter!(x => x > 0)
         .map!(x => 1 << (x - 1))
         .sum
         .writeln;
}
