import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;

void main(string[] args)
{
    stdin.byLineCopy
         .map!(x => x.retro.find!(c => c.isDigit)
                     .retro.find!(c => c.isDigit))
         .map!(x => 10*(x[0] - '0') + (x[$-1] - '0'))
         .sum
         .writeln;
}
