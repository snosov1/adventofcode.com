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

Tuple!(int, int) segments_union_measure(int[][] a)
{
	auto n = a.length;
    Tuple!(int, bool)[] x;
    x.length = n * 2;
	foreach (i; 0..n)
	{
		x[i*2]   = tuple(a[i][0], false);
		x[i*2+1] = tuple(a[i][1], true);
	}

	x.sort!((a, b) => a[0] < b[0] || (a[0] == b[0] && a[1] < b[1]));

	int result = 0;
	int c = 0;
    int prev = x[0][0];
    int outsider = -1;
	foreach (i; 0..n*2)
	{
        debug writeln("c = ", c, ", x[i][0] = ", x[i][0]);

		if (c && i)
        {
			result += x[i][0] - x[i-1][0];
            if (prev != x[i-1][0])
                outsider = prev + 1;

            prev = x[i][0];
        }
		if (x[i][1])
			++c;
		else
			--c;
	}
	return tuple(result, outsider);
}

void main(string[] args)
{

    auto input = stdin.byLine.map!((x){
        int[4] a;
        x.formattedRead("Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d", a[0], a[1], a[2], a[3]);
        return a;
    }).array;

    int minxy = 0, maxxy = 4_000_000;
    foreach (y; minxy..maxxy+1)
    {
        auto segments = input.map!((a) {
            a[2..$][] -= a[0..2][];
            return [clamp(a[0] - abs(a[2]) - abs(a[3]) + abs(y - a[1]), minxy, maxxy),
                    clamp(a[0] + abs(a[2]) + abs(a[3]) - abs(y - a[1]), minxy, maxxy)];
        }).filter!(x => x[0] < x[1]).array;

        auto result = segments.segments_union_measure;
        if (result[0] == maxxy - minxy - 2)
        {
            writeln(result[1] * 4_000_000L + y);
        }
    }
}
