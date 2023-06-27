import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;

long mod(long x, long m)
{
    return ((x % m) + m) % m;
}

int main(string[] args)
{
    auto a = stdin.byLine.map!(x => x.to!long).enumerate.array;
    auto ad = a.dup;

    enum key = 811589153;

    auto curr = ad;
    foreach(i; 0..10)
    {
        foreach (x; a)
        {
            auto found = curr.find(x);
            int oldo = a.length - found.length;
            int newo = mod(oldo + x[1]*key, a.length - 1).to!int;

            curr = indexed(curr, newo >= oldo
            ? chain(iota(oldo), iota(oldo + 1, newo + 1), iota(oldo, oldo + 1), iota(newo + 1, a.length))
            : chain(iota(newo), iota(oldo, oldo + 1), iota(newo, oldo), iota(oldo + 1, a.length))).array;

            debug curr.map!(x => x[1]).writeln;
        }
    }

    auto found = curr.find!(o => o[1] == 0);
    auto zero_idx = curr.length - found.length;

    [1000, 2000, 3000].map!(x => curr[mod(zero_idx + x, curr.length).to!uint][1] * key)
                      .sum.writeln;

    // 2159638736133 - correct

    return 0;
}
