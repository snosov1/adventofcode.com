import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.string;

void main(string[] args)
{
    auto input = stdin.byLine.front;

    auto f = input.slide(14)
                  .enumerate
                  .find!(x => x[1].array.sort.uniq.walkLength == 14);

    writeln(f.front[0] + 14);
}
