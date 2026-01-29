import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.math;

void main(string[] args)
{
    stdin.byLineCopy
         .map!(x => x.split.map!(y => y.to!int)).array
         .transposed.map!(x => x.array.sort).array
         .transposed.map!(x => x.array)
         .map!(x => abs(x[0] - x[1]))
         .sum
         .writeln;
}
