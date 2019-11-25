import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.typecons;
import std.math;

struct Point {
    long x, y;
    long vx, vy;

    this(long x, long y, long vx, long vy)
    {
        this.x  = x;
        this.y  = y;
        this.vx = vx;
        this.vy = vy;
    }

    this(string s) {
        s.formattedRead!"position=<%s,%s> velocity=<%s,%s>"(x, y, vx, vy);
    }
}

long display(Point[] input, bool call_write=false)
{
    auto mx = input.map!(a => a.x).minElement;
    auto my = input.map!(a => a.y).minElement;
    input.map!(a => Point(a.x - mx, a.y - my, a.vx, a.vy)).copy(input);

    auto nx = input.map!(a => a.x).maxElement + 1;
    auto ny = input.map!(a => a.y).maxElement + 1;

    if (call_write)
    {
        auto field = new char[][](ny, nx);
        foreach (f; field)
            f[] = '.';

        foreach (p; input)
            field[p.y][p.x] = '#';


        foreach (f; field)
            writeln(f);
    }

    return nx * ny;
}

int main(string[] args)
{
    auto input = stdin.byLine.map!(a => Point(a.filter!(a => a != ' ')
                                               .to!string)).array;

    long marea = long.max;
    long area = long.max - 1;
    long count = 0;

    while (area < marea)
    {
        count++;
        input.map!(a => Point(a.x + a.vx, a.y + a.vy, a.vx, a.vy)).copy(input);
        marea = area;
        area = display(input);
    }

    writeln(count - 1);

    return 0;
}
