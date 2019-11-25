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
import std.functional;

struct Mark
{
    int step;
    int id = -1;
}

void outputField(Mark[][] field, int nx, int ny)
{
    for (int j = 0; j < ny; j++)
    {
        for (int i = 0; i < nx; i++)
        {
            auto id = field[i][j].id;
            if (id == -1)
                write('*');
            else if (id == -2)
                write('.');
            else
                write(id);
        }
        writeln;
    }
}



void main(string[] args)
{
    auto input = stdin.byLine
                      .map!(a => a.split(", ").to!(int[]))
                      .array;
    auto mx = input.map!(a => a[0]).minElement;
    auto my = input.map!(a => a[1]).minElement;
    input.map!(a => [a[0] - mx, a[1] - my]).copy(input);

    auto nx = input.map!(a => a[0]).maxElement + 1;
    auto ny = input.map!(a => a[1]).maxElement + 1;

    //enum limit = 32;
    enum limit = 10000;

    int a = 0, b = 0;

    //input.map!(x => abs(a - x[0]) + abs(b - x[1])).each!(a => a.writeln);

    alias dist = binaryFun!((X, Y) {
        return input.map!(x => abs(X - x[0]) + abs(Y - x[1])).sum;
    });

    //dist(0, 0).writeln;

    auto sx = cast(int)sequence!"n"               .find!(a => dist(-cast(int)a,           0) > limit).front;
    auto sy = cast(int)sequence!"n"               .find!(a => dist(sx         , -cast(int)a) > limit).front;
    auto ex = cast(int)sequence!((a, n) => n + nx).find!(a => dist(cast(int)a ,           0) > limit).front;
    auto ey = cast(int)sequence!((a, n) => n + ny).find!(a => dist(ex         ,  cast(int)a) > limit).front;

    int s = 0;
    for (int x = sx; x <= ex; x++)
    {
        for (int y = sy; y <= ey; y++)
        {
            if (dist(x, y) < limit)
                s++;
        }
    }

    s.writeln;

    //pragma(msg, isBidirectionalRange!(typeof(sequence!"-n".until!(a => dist(a, 0) > limit))));

    //sequence!"n + 1".until(10).writeln;

}
