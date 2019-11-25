import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;

struct claim_t {
    int id, x, y, w, h;
    this(string s) {
        s.formattedRead!"#%s @ %s,%s: %sx%s"(id, x, y, w, h);
    }
}

void main(string[] args)
{
    enum N = 1000;
    auto field = new int[][](N, N);

    foreach (a; stdin.byLine
                     .map!(x => claim_t(x.to!string)))
    {
        for (int y = a.y; y < a.y + a.h; y++)
            ++field[y][a.x .. a.x + a.w];
    }

    writeln(field.join
                 .map!(a => a > 1 ? 1 : 0)
                 .sum);
}
