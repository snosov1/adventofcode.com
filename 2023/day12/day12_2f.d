import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;
import std.functional;

long fit0(string condition, int[] list)
{
    if (list.empty)
        return condition.empty || condition.all!(x => x != '#') ? 1 : 0;

    condition = condition.find!(x => x != '.');
    if (condition.length < list[0])
        return 0;

    if (condition.front == '#')
    {
        if (condition[0..list[0]].any!(x => x == '.'))
            return 0;

        if (condition.length == list[0])
            return list.length == 1;

        if (condition[list[0]] == '#')
            return 0;

        return fit(condition[list[0]+1..$], list[1..$]);
    }

    long f1 = fit("#" ~ condition[1..$], list);

    long f2 = fit(condition[1..$], list);

    return f1 + f2;
}

long comb0(long n, int[] l)
{
    //write(q, " ", l);

    if (l.empty)
        return 0; // ?

    if (n < l.sum + l.length - 1)
        return 0;

    if (l.length == 1)
        return n - l[0] + 1;

    long ans = 0;
    foreach (i; iota(n - l[0] - 1))
    {
        ans += comb(n - l[0] - 1 - i, l[1..$]);
    }

    // writeln("n = ", n);
    // writeln("ans = ", ans);

    return ans;

    // if (l.length == 1)
    // {
    //     return q - l[0] + 1;
    // }
    // long ans = 0;
    // foreach (i; iota(q - l[0] - 1))
    // {
    //     if (l.sum + l.length - 1 <= q)
    //         ans += comb(q - i - l[0] - 1, l[1..$]);
    // }

    // writeln("ret = ", ans);
    // return ans;
}



long nchoosek(long n, long k)
{
    if (k == 0)
        return 1;
    return (n * memoize!nchoosek(n - 1, k - 1)) / k;
}

long comb(long q, int[] l)
{
    if (l.empty)
        return 1;

    long n = q - (l.sum + l.length - 1);
    long k = l.length + 1;

    if (n < 0)
        return 0;

    return nchoosek(n + k - 1, k - 1);
}

unittest
{
    assert(comb(5, [1]) == 5);
    assert(comb(2, [1]) == 2);
    assert(comb(3, [1]) == 3);
    assert(comb(3, [1, 1]) == 1);
    assert(comb(5, [1, 1]) == 6);
    assert(comb(5, [1, 1, 1]) == 1);
    assert(comb(7, [2, 1]) == 10);
    assert(comb(10, [2, 1, 3]) == 10);

    //comb(5, [2, 1, 3, 2, 1]).writeln;

    //comb(10, [2, 1, 3]).writeln;
}

long comb(long[] q, int[] l)
{
    if (l.empty)
        return 1;

    if (q.empty)
        return l.empty ? 1 : 0;

    if (q.length == 1)
        return comb(q.front, l);

    long ans = 0;
    foreach (i; iota(l.length+1))
    {
        ans += comb(q[0], l[0..$-i]) * comb(q[1..$], l[$-i..$]);

        //writeln([q[0]], l[0..$-i], q[1..$], l[$-i..$], ans);
    }

    return ans;
}

unittest
{
    assert(comb([10], [2, 1, 3]) == 10);
    assert(comb([2, 2], [1, 1]) == 4);
    assert(comb([3], [1, 1]) == 1);
    assert(comb([2, 3], [1, 1]) == 7);
    assert(comb([2, 3, 2], [1, 1]) == 17);
}

long fit1(string condition, int[] list)
{
    if (list.empty)
        return condition.empty || condition.all!(x => x != '#') ? 1 : 0;

    condition = condition.find!(x => x != '.');
    if (condition.length < list[0])
        return 0;

    if (condition.front == '#')
    {
        if (condition[0..list[0]].any!(x => x == '.'))
            return 0;

        if (condition.length == list[0])
            return list.length == 1;

        if (condition[list[0]] == '#')
            return 0;

        return fit(condition[list[0]+1..$], list[1..$]);
    }

    auto qe = condition.find!(x => x != '?');
    long q = condition.length - qe.length;
    if (!qe.empty && qe.front == '#')
        q--;
    //writeln(condition, " ", qe, " ", q);
    long f = 0;

    //writeln(condition);
    if (list[0] < q)
    {
        foreach (i; iota(1, list.length+1))
        {
            long f1 = comb(q, list[0..i]);
            long f2 = fit(condition[q.to!int..$], list[i..$]);

            // writeln(q, " ", list[0..i], " ", f1);
            // writeln(condition[q.to!int..$], " ", list[i..$], " ", f2);

            f += f1 * f2;
            //f += f2;
        }

        f += fit(condition[q.to!int..$], list);
    }
    else
    {
        f += fit("#" ~ condition[1..$], list);
        f += fit(condition[1..$], list);
    }

    return f;
}

long fit(string condition, int[] list)
{
    long ans = 0;
    auto sharp = condition.find("#");
    if (sharp.empty)
    {
        ans = comb(condition.group.filter!(x => x[0] == '?').map!(x => x[1].to!long).array, list);
    }
    else
    {
        int idx = condition.length - sharp.length;
        foreach (i; iota(list.length))
        {
            int n = list[i];
            foreach (j; iota(n))
            {
                int l = idx - j;
                int r = idx - j + n;
                if (l >= 0 && r < condition.length && condition[l..r].all!(x => x != '.'))
                {
                    if (l > 0 && condition[l-1] != '#')
                        l--;
                    if (r < condition.length - 1 && condition[r] != '#')
                        r++;

                    ans += fit(condition[0..l], list[0..i]) * fit(condition[r..$], list[i+1..$]);
                }
            }
        }
    }

    writeln(condition, list, ans);
    return ans;
}

void main(string[] args)
{
    int s = 0;
    foreach (line; stdin.byLineCopy)
    {
        auto entry = line.split;
        auto condition = entry.front;
        auto list = entry.back.split(',').map!(x => x.to!int).array;

        auto condition5 = iota(5).map!(x => condition).join('?');
        auto list5 = iota(5).map!(x => list).join;

        writeln(condition5, " ", list5);
        //writeln();
        // s +=
        // fit(condition, list);

        s +=
        fit0(condition5, list5);

        writeln("qq ", s);
        stdout.flush;
    }

    s.writeln;
}
