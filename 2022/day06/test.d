import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.string;

void main(string[] args)
{
    auto input = stdin.byLine.front;

    char[] arr;
    arr.length = 4;

    auto f = input.slide(4)
                  .map!(x => x.copy(arr));

    writeln(f);
}
