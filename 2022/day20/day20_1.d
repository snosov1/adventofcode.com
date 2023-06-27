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

    auto amin = a.minElement!(x => x.value).value;
    auto amax = a.maxElement!(x => x.value).value;

    int N = amax - amin + 1;
    int[Tuple!(uint, int)] order;

    Tuple!(uint, int) zero;
    foreach (x; a)
    {
        if (x[1] == 0)
            zero = tuple(x[0], x[1] - amin);
        order[tuple(x[0], x[1] - amin)] = x[0];
    }

    //writeln(order);

    foreach (x; a)
    {
        debug {
            int[] ad;
            ad.length = a.length;
            foreach (i, o; order)
                ad[o] = i[1] + amin;
            ad.writeln;
        }

        // debug {
        //     x.writeln;
        //     a.writeln;
        //     auto ad = a.dup;
        //     ad.sort.writeln;
        //     order.writeln;
        //     foreach (i, o; order.enumerate)
        //         if (o >= 0)
        //             ad[o] = i + amin;
        //     ad.writeln;
        // }

        auto oldo = order[tuple(x[0], x[1] - amin)];
        auto newo = order[tuple(x[0], x[1] - amin)] + x[1];
        newo = mod(newo, a.length - 1);

        // if (newo < 0 || newo >= a.length)
        //     newo += x[1].sgn;
        // newo = mod(newo, a.length);

        // debug writeln(oldo, " ", oldo + x, " ", newo);
        // debug writeln;

        if (newo >= oldo)
            order.byValue
                 .filter!(o => o > oldo && o <= newo)
                 .each!((ref o){o = mod(o - 1, a.length);});
        else
            order.byValue
                 .filter!(o => o >= newo && o < oldo)
                 .each!((ref o){o = mod(o + 1, a.length);});

        order[tuple(x[0], x[1] - amin)] = newo;
    }

    debug {
        int[] ad;
        ad.length = a.length;
        foreach (i, o; order)
            ad[o] = i[1] + amin;
        ad.writeln;
    }

    // foreach (k, v; order)
    // {
    //     if (v == mod(order[zero] + 1000, a.length))
    //         writeln(k, " ", v);
    // }

    [1000, 2000, 3000].map!(x =>
        order.byKeyValue
             .find!(o => mod(order[zero] + x, a.length) == o.value)
             .front.key[1].to!int + amin
        ).sum.writeln;

    // 8713 - too high

    return 0;
}
