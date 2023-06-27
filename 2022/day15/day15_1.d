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

int segments_union_measure(int[][] a)
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
	foreach (i; 0..n*2)
	{
        debug writeln("c = ", c, ", x[i][0] = ", x[i][0]);

		if (c && i)
			result += x[i][0] - x[i-1][0];
		if (x[i][1])
			++c;
		else
			--c;
	}
	return result;
}

void main(string[] args)
{

    auto segments = stdin.byLine.map!((x){
        int[4] a;
        x.formattedRead("Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d", a[0], a[1], a[2], a[3]);
        return a;
    }).map!((a) {
        a[2..$][] -= a[0..2][];
        int y = 2_000_000;
        //int y = 10;
        return [a[0] - abs(a[2]) - abs(a[3]) + abs(y - a[1]),
                a[0] + abs(a[2]) + abs(a[3]) - abs(y - a[1])];
    }).filter!(x => x[0] < x[1]).array;

    segments.segments_union_measure.writeln;

    // writeln(segments_union_measure([
    //     [1, 3],
    //     ]));

    // 0 1 2 3 . 5 6 7

}
