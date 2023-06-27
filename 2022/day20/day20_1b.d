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

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

int main(string[] args)
{
    auto a = stdin.byLine.map!(x => x.to!int).enumerate.array;
    auto ad = a.dup;

    // int oldo = 5, newo = 3;
    // if (newo >= oldo)
    // {
    //     auto index = chain(iota(oldo), iota(oldo + 1, newo + 1), only(oldo), iota(newo + 1, a.length));
    //     writeln(iota(oldo), iota(oldo + 1, newo + 1), only(oldo), iota(newo + 1, a.length));
    // }
    // else
    // {
    //     auto index = chain(iota(newo), only(oldo), iota(newo, oldo), iota(oldo + 1, a.length));
    //     writeln(iota(newo), only(oldo), iota(newo, oldo), iota(oldo + 1, a.length));
    // }

    // auto index = chain(iota(a.length), iota(0), iota(0), iota(0));
    // auto curr = indexed(ad, index).array;

    auto curr = ad;
    foreach (x; a)
    {
        auto found = curr.find(x);
        int oldo = a.length - found.length;
        int newo = mod(oldo + x[1], a.length - 1);

        // int newo = oldo + x[1];
        // if (newo < 0 || newo >= a.length)
        //     newo += x[1].sgn;
        // newo = mod(newo, a.length);

        curr = indexed(curr, newo >= oldo
            ? chain(iota(oldo), iota(oldo + 1, newo + 1), iota(oldo, oldo + 1), iota(newo + 1, a.length))
            : chain(iota(newo), iota(oldo, oldo + 1), iota(newo, oldo), iota(oldo + 1, a.length))).array;

        debug curr.map!(x => x[1]).writeln;
    }

    auto found = curr.find!(o => o[1] == 0);
    auto zero_idx = curr.length - found.length;

    [1000, 2000, 3000].map!(x => curr[mod(zero_idx + x, curr.length)][1])
                      .sum.writeln;

    return 0;
}
