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

int surface(int[][] cubes)
{
    int s = 0;
    foreach (axes; [[0, 1, 2], [0, 2, 1], [1, 2, 0]])
    {
        int[] mins, maxs;
        foreach (a; axes)
        {
            auto as = cubes.map!(x => x[a]);
            mins ~= as.minElement;
            maxs ~= as.maxElement;
        }

        foreach (cp; cartesianProduct(iota(mins[0], maxs[0] + 1), iota(mins[1], maxs[1] + 1)))
        {
            s +=
            cubes.filter!(x => x[axes[0]] == cp[0] && x[axes[1]] == cp[1])
                 .map!(x => x[axes[2]])
                 .array
                 .sort
                 .splitWhen!((a,b)=>b-a>1)
                 .walkLength
            * 2;
        }
    }

    return s;
}

int main(string[] args)
{
    auto cubes = stdin.byLine.map!(line =>
        line.split(",").map!(x => x.to!int).array
        ).array;

    int[int[]] pockets;

    int s = 0;
    foreach (axes; [[0, 1, 2], [0, 2, 1], [1, 2, 0]])
    {
        int[] mins, maxs;
        foreach (a; axes)
        {
            auto as = cubes.map!(x => x[a]);
            mins ~= as.minElement;
            maxs ~= as.maxElement;
        }

        foreach (cp; cartesianProduct(iota(mins[0], maxs[0] + 1), iota(mins[1], maxs[1] + 1)))
        {
            auto sorted =
                cubes.filter!(x => x[axes[0]] == cp[0] && x[axes[1]] == cp[1])
                     .array
                     .sort!((a, b) => a[axes[2]] < b[axes[2]]);

            if (!sorted.empty)
            {
                foreach (sign; [1, -1])
                {
                    int idx = 0;
                    foreach (i; iota(sorted[sign == 1 ? 0   : $-1][axes[2]],
                                     sorted[sign == 1 ? $-1 : 0  ][axes[2]],
                                     sign))
                    {
                        if (i == sorted[idx][axes[2]])
                            idx += sign;
                        else
                        {
                            int[] key;
                            key.length = 3;
                            key[axes[0]] = cp[0];
                            key[axes[1]] = cp[1];
                            key[axes[2]] = i;

                            pockets.update(key,
                            () => 1,
                            (ref int old) {
                                old++;
                            });
                        }
                    }
                }
            }
        }
    }

    //writeln(pockets);

    int[][] pocket_cubes;
    pockets.keys.filter!(x => pockets[x] == 6).tee!(key => pocket_cubes ~= key.dup).array;

    bool found = true;
    while (found)
    {
        found = false;
        foreach (i, p; pocket_cubes.enumerate)
        {
            if (found)
                break;

            foreach (off; [
                [0, 0, 1], [0, 0, -1],
                [0, 1, 0], [0, -1, 0],
                [1, 0, 0], [-1, 0, 0]
                ])
            {
                int[] c;
                c.length = 3;
                c[] = p[] + off[];

                if ((!cubes.canFind(c)) && pockets[c] != 6)
                //if (!pocket_cubes.canFind(c))
                {
                    found = true;
                    pocket_cubes = pocket_cubes[0..i] ~ pocket_cubes[i+1..$];
                    break;
                }
            }
        }
    }

    writeln(cubes.surface - pocket_cubes.surface);
    //writeln(pockets);
    //writeln(pocket_cubes);

    // 2052 - correct in task 2!!!
    // 2802 - too high
    // 2040 - too low
    // 3448 - correct in task 1

    return 0;
}
