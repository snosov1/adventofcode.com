import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.math;
import std.typecons;
import std.functional;

void main(string[] args)
{
    stdin.byLineCopy
         .map!(x => x.split.map!(y => y.to!int)).array
         .transposed.map!(x => x.array.sort).array
         .pipe!(x => x.front.cartesianProduct(only(x.back)))
         .map!(x => x[0] * x[1].equalRange(x[0]).length)
         .sum
         .writeln;
}
