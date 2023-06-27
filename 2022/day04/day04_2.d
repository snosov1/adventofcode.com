import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{
    stdin.byLine.map!((x){
        int[4] a;
        x.formattedRead("%d-%d,%d-%d", a[0], a[1], a[2], a[3]);
        return a;
    }).count!(a => (a[2] <= a[0] && a[3] >= a[0]) || (a[2] > a[0] && a[2] <= a[1]))
      .writeln;
}
