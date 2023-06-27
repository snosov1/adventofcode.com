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

immutable shapes = [
    ["@@@@"],

    [".@.",
     "@@@",
     ".@."],

    ["..@",
     "..@",
     "@@@"],

    ["@",
     "@",
     "@",
     "@"],

    ["@@",
     "@@"]
    ];

string merge(string src, string dst)
{
    return zip(src, dst).map!((x){
        if (x[1] == '.')
            return x[0];

        return x[0] == '.' || x[0] == '+' ? x[1] : '*';
    }).to!string;
}

unittest
{
    assert(merge("+.@.....+", "+....#..+") == "+.@..#..+");
    assert(merge("+....@..+", "+....#..+") == "+....*..+");
    assert(merge("+.......@", "+....#..+") == "+....#..*");
}

string extend(string src, int posx)
{
    string d = "+";
    if (posx < 0)
    {
        if (src.front != '.')
            d = "*";
        src = src[1..$];
    }

    foreach (i; 0..posx)
        d ~= ".";

    d ~= src;

    foreach (i; 0..8L - d.length)
        d ~= ".";

    if (d.length == 9)
        return d[0..$-1] ~ (d[$-1] == '.' ? "+" : "@");

    return d ~ "+";
}

unittest
{
    assert(extend(".@.", 0)  == "+.@.....+");
    assert(extend(".@.", 2)  == "+...@...+");
    assert(extend(".@.", 5)  == "+......@+");

    assert(extend(".@.", -1) == "+@......+");
    assert(extend("@@@", -1) == "*@@.....+");
}

void main(string[] args)
{
    char[][] field = ["+#######+".dup];

    string jets = readln.strip;

    auto shapes_cycle = shapes.cycle;
    auto jets_cycle = jets.cycle;

    int[] ans;

    foreach (sn; 0..20220)
    {
        int posx = 2, posy = 0;
        auto shape = shapes_cycle.front;
        shapes_cycle.popFront;

        // grow
        auto top = field.retro.find!(x => x[1..$-1].canFind('#'));
        auto add = 3L + shape.length - field.length + top.length;
        foreach (i; 0..max(0, add))
            field ~= "+.......+".dup;
        if (add < 0)
            posy = -add.to!int;

        foreach (t; sequence!((a,n) => n))
        {
            auto jet = jets_cycle.front.to!char;

            if (t % 2 == 0)
            {
                posx += jet == '>' ? 1 : -1;
                debug writeln("jet ", jet);
            }
            else
            {
                debug writeln("move down");
                posy++;
            }

            debug
            {
                foreach (i; 0..posy)
                    field[$ - 1 - i].writeln;
            }

            bool rest = false;
            foreach (i; 0..shape.length)
            {
                auto m = merge(
                    extend(shape[i], posx),
                    field[$ - 1 - posy - i].to!string
                    );

                if (m.canFind('*'))
                {
                    if (t % 2 == 0)
                    {
                        posx += jet == '<' ? 1 : -1;
                        debug writeln("revert jet");
                    }
                    else
                    {
                        posy--;
                        rest = true;
                        break;
                    }
                }

                debug m.writeln;
            }

            debug
            {
                foreach (i; posy + shape.length..field.length)
                    field[$ - 1 - i].writeln;
            }

            debug writeln;

            if (rest)
            {
                foreach (i; 0..shape.length)
                {
                    auto m = merge(
                        extend(shape[i], posx),
                        field[$ - 1 - posy - i].to!string
                        );
                    m.map!(x => x == '@' ? '#' : x).copy(field[$ - 1 - posy - i]);
                }

                debug writeln("rest");
                break;
            }

            if (t % 2 == 0)
                jets_cycle.popFront;
        }

        ans ~= field[1..$].filter!(x => x.canFind('#')).walkLength;
    }

    auto diff = zip(ans[0..$-1], ans[1..$]).map!(x => x[1] - x[0]).array;

    int n = diff.length;
    long N = 1_000_000_000_000;
    foreach (int off; 0..n)
    {
        foreach (int cl; 6..n)
        {
            int l = off;
            int r = off + cl;

            int ll = l + cl;
            int rr = r + cl;

            if (
                l < 0  || l >= n  || r < 0  ||  r >= n ||
                ll < 0 || ll >= n || rr < 0 || rr >= n
                )
                break;

            if (equal(
                diff[l..r],
                diff[ll..rr]
                ))
            {
                long d = diff[off..off+cl].sum;
                long k  = (N - off) / cl;
                long r1 = (N - off) % cl;

                long ans2 = k * d + diff[off..(off+r1-1).to!uint].sum + ans[off];
                ans2.writeln;
                return;
            }
        }
    }

    ans[2022 - 1].writeln;
}
