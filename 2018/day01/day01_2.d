import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;

void main(string[] args)
{
    bool[int] dict;
    int s = 0;

    stdin.byLine
         .map!(x => x.to!int)
         .array
         .cycle
         .until!(x => s in dict)
         .each!((x){
             dict[s] = true;
             s += x;
         });

    writeln(s);
}
