import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;

void main(string[] args)
{
    auto input = stdin.byLine.front;

    for (int i = 0; i < input.length - 1; )
    {
        if (input[i].toUpper == input[i+1].toUpper && input[i] != input[i+1])
        {
            input = input[0..i] ~ input[i+2..$];
            i = max(0, i-1);
        }
        else
        {
            i++;
        }
    }

    input.length.writeln;
}
