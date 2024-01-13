import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;

void main(string[] args)
{
    enum d = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        ];



    int s = 0;
    foreach (line; stdin.byLineCopy)
    {
        for(;!line.empty;line.popFront)
            if (d.keys.map!(x => line.startsWith(x)).any)
                break;

        for(;!line.empty;line.popBack)
            if (d.keys.map!(x => line.endsWith(x)).any)
                break;

        s += 10 * d[d.keys.filter!(x => line.startsWith(x)).front] +
                  d[d.keys.filter!(x => line.endsWith(x)).front];
    }

    writeln(s);

}
