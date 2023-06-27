import std.stdio;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args)
{
    stdin.byLineCopy.array.splitter("")
         .map!(x => x.fold!((a, b) => a.to!int + b.to!int)(0))
         .maxElement
         .writeln;
}
