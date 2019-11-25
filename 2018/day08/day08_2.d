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

int sum_meta(int[] tree, ref int s)
{
    int n = tree[0];
    int m = tree[1];

    debug writeln("start ", n, " ", m);

    if (n == 0)
    {
        debug writeln("empty, s = ", s, " + ", tree[2..2 + m].sum, " length = ", 2 + m);

        s = tree[2..2 + m].sum;
        return 2 + m;
    }

    auto vals = new int[n];
    int len = 2;
    tree = tree[2..$];
    for (int i = 0; i < n; i++)
    {
        int k = sum_meta(tree, vals[i]);
        len += k;
        tree = tree[k..$];
        debug writeln("child, k = ", k);
    }

    debug writeln("vals = ", vals, ", meta = ", tree[0..m]);
    for (int i = 0; i < m; i++)
    {
        int idx = tree[i] - 1;
        if (idx >= 0 && idx < n)
            s += vals[idx];
    }

    len += m;
    return len;
}

int main(string[] args)
{
    auto input = readln.split.map!(a => a.to!int).array;

    int s = 0;
    sum_meta(input, s);

    writeln(s);

    return 0;
}
