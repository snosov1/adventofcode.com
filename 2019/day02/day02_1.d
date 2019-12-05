import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.string;

void main(string[] args)
{
    int[] a;
    stdin.readln.strip.formattedRead!"%(%s,%)"(a);

    a[1] = 12;
    a[2] = 2;

    int i = 0;
    while (true)
    {
        if (a[i] == 1)
            a[a[i + 3]] = a[a[i + 1]] + a[a[i + 2]];
        else if (a[i] == 2)
            a[a[i + 3]] = a[a[i + 1]] * a[a[i + 2]];
        else
            break;
        i += 4;
    }

    a[0].writeln;
}
