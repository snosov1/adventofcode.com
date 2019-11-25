import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.typecons;
import std.math;

int cw(int c, int s, int n)
{
    return (c + s) % n;
}

int acw(int c, int s, int n)
{
    c = c - s % n;
    return c < 0 ? n + c : c;

}

int rot(int c, int s, int n)
{
    return s >= 0 ? cw(c, s, n) : acw(c, -s, n);
}

unittest
{
    assert(cw(3, 1, 4) == 0);
    assert(cw(3, 1 + 4*100, 4) == 0);
    assert(cw(3, 3 + 4*17, 4) == 2);

    assert(acw(0, 1, 4) == 3);
    assert(acw(0, 1 + 4*19, 4) == 3);
}

int main(string[] args)
{
    auto input = readln.split.array;
    auto n = input[0].to!int;
    auto m = input[6].to!int;

    int curr_idx = 0;
    int curr_player = 0;
    auto field = [0];
    auto scores = new int[n];

    for (int i = 1; i <= m; i++)
    {
        debug field.enumerate.map!(a => a[0] == curr_idx ? -a[1] : a[1]).array.writeln;

        if (i % 23 != 0)
        {
            curr_idx = rot(curr_idx, 2, cast(int)field.length);
            field = field[0..curr_idx] ~ i ~ field[curr_idx..$];
        }
        else
        {
            scores[curr_player] += i;
            curr_idx = rot(curr_idx, -7, cast(int)field.length);
            debug writeln("curr_idx = ", curr_idx, " ", field[curr_idx]);
            scores[curr_player] += field[curr_idx];
            field = field[0..curr_idx] ~ field[curr_idx + 1..$];
            debug writeln("scores: ", scores);
        }
        curr_player = (curr_player + 1) % n;
    }

    scores.maxElement.writeln;

    return 0;
}
