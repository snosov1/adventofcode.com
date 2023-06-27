import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;
import std.ascii;
import std.process;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

void normalize(ref int[] rep, int b = 5)
{
    int b2 = b / 2;

    for (int i = 0; i < rep.length; i++)
    {
        debug writeln("i = ", i);

        if (rep[i] > b2)
        {
            int carry = (rep[i] + b2) / b;
            int rem = rep[i] - carry * b;
            rep[i] = mod(rem + b2, b) - b2;
            if (i == rep.length - 1)
                rep.length++;
            rep[i+1] += carry;

            debug writeln("carry = ", carry, " rem = ", rem, " rep[i] = ", rep[i], " rep[i+1] ", rep[i+1]);
        }
    }
}

int main(string[] args)
{
    enum digit = [
        '0' : 0,
        '1' : 1,
        '2' : 2,
        '-' : -1,
        '=' : -2,
        ];
    enum repr = [
         0 : '0',
         1 : '1',
         2 : '2',
        -1 : '-',
        -2 : '=',
        ];

    enum long base = 5;
    long s = 0;
    foreach (line; stdin.byLine)
    {
        long e = 1;
        long v = 0;
        foreach (c; line.retro)
        {
            v += digit[c.to!char] * e;
            e *= 5;
        }
        s += v;
    }

    // to regular base=5
    int[] rep;
    int e = 1;
    while (s > base)
    {
        long d = s % (e * base);
        rep ~= (d / e).to!int;
        s -= d;
        e *= base;
    }

    normalize(rep);
    rep.retro.map!(x => repr[x]).writeln;

    return 0;
}
