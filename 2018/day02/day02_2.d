import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;

void main(string[] args)
{
    auto input = stdin.byLine
                      .map!(x => x.array)
                      .array;

    auto q = input.cartesianProduct(input)
                  .find!((x, y) => levenshteinDistance(x[0], x[1]) == y)(1)
                  .front;

    zip(q[0], q[1]).filter!(x => x[0] == x[1])
                   .map!(x => x[0])
                   .writeln;
}
