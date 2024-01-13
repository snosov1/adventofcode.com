import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;

void main(string[] args)
{
    auto instructions = stdin.byLineCopy.front;
    stdin.byLineCopy.popFront;

    string[2][string] nodes;
    foreach (line; stdin.byLineCopy)
    {
        string k;
        string[2] n;
        line.formattedRead("%s = (%s, %s)", k, n[0], n[1]);
        nodes[k] = n;
    }

    string curr = "AAA";
    int steps = 0;
    foreach (i; instructions.cycle)
    {
        steps++;
        curr = nodes[curr][i == 'R' ? 1 : 0];
        if (curr == "ZZZ")
            break;
    }

    steps.writeln;
}
