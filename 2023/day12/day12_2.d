// Dynamic programming. f (pos, groups, len) = number of ways to:

// - parse the first pos positions
// - have groups groups of #
// - with the last group of # having length len

// The transitions are:

// - if the character is # or ?, we can continue the previous group or start a new group:

//   f (pos + 1, groups + (len == 0), len + 1) += f (pos, groups, len)

// - if the character is . or ?, and the length of the current group is zero or
//   exactly what we need, we can proceed without a group:

//   f (pos + 1, groups, 0) += f (pos, groups, len)

// In the end, the answer is f (lastPos, numberOfGgroups, 0). (Add a trailing
// . to the string for convenience to avoid cases.)


import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;

void main(string[] args)
{
	long res = 0;
	foreach (ref b; stdin.byLineCopy) {
		auto t = b.split;
		auto s = t[0];
		s = s.repeat(5).join('?');
		s ~= '.';
		auto a = t[1].split(",").map!(to!int).array;
		a = a.repeat(5).join;
		auto n = s.length.to!int;
		auto k = a.length.to!int;
		a ~= n + 1;

		auto f = new long[][][](n + 1, k + 2, n + 2);
		f[0][0][0] = 1;
		foreach (i; 0..n)
			foreach (j; 0..k + 1)
				foreach (p; 0..n + 1) {
					auto cur = f[i][j][p];
					if (!cur)
						continue;
                    if (s[i] == '#' || s[i] == '?')
						f[i + 1][j + !p][p + 1] += cur;
					if (s[i] == '.' || s[i] == '?')
						if (p == 0 || p == a[j - 1])
							f[i + 1][j][0] += cur;
				}
		res += f[n][k][0];
	}
	writeln (res);
}
