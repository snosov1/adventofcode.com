import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;

void main(string[] args)
{
    auto input = stdin.byLine
                      .map!(x => x.array.sort.group)
                      .array;

    writeln(
        input.count!(x => x.canFind!((a, b) => a[1] == b)(2)) *
        input.count!(x => x.canFind!((a, b) => a[1] == b)(3))
    );
}
