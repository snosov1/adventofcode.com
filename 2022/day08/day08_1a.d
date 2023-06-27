import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;

void main(string[] args)
{
    auto input = stdin.byLine;
    int N = input.front.length, M = 0;
    int[] field;

    foreach (ref i; input)
    {
        field.length += N;
        i.map!(x => x.to!int - '0').copy(field[$-N..$]);
        M++;
    }

    cartesianProduct(iota(M), iota(N)).map!(pos =>
        [[1, 0], [-1, 0], [0, 1], [0, -1]]
        .map!(off =>
            recurrence!((a, n) => [a[n-1][0] + off[0], a[n-1][1] + off[1]])([pos[0], pos[1]])
            .until!(a => a[0] < 0 || a[0] >= M || a[1] < 0 || a[1] >= N)
            .map!(idx => field[idx[0] * N + idx[1]])
        )
        .map!(ray =>
            ray.front > ray.drop(1).chain(only(-1)).maxElement)
        .any)
    .count(true)
    .writeln;

    //x + off[0] * N + x % N + off[1];

    // //cartesianProduct(iota(M), iota(N))
    // only([0, 0])
    // .map!(pos =>
    //     [[1, 0], [-1, 0], [0, 1], [0, -1]]
    //     .map!(off =>
    //         recurrence!((a, n) => a[n-1] + off[0] * N + a[n-1] % N + off[1])(pos[0] * N + pos[1])
    //     .tee!(x => x.writeln)
    //         .until!(a => a / N < 0 || a / N >= M || a % N < 0 || a % N >= N)
    //         .map!(idx => field[idx])
    //         )
    //     .map!(ray =>
    //         ray.front > ray.drop(1).chain(only(-1)).maxElement)
    //     .any
    //     )
    // .count(true)
    // //.writeln
    // ;
}
