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

    debug writeln("start ", n, " ", m, " s = ", s);

    int len = 2;
    tree = tree[2..$];
    for (int i = 0; i < n; i++)
    {
        int k = sum_meta(tree, s);
        len += k;
        tree = tree[k..$];
        debug writeln("child, k = ", k);
    }

    s += tree[0..m].sum;
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
