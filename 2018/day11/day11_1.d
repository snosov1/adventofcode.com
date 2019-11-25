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

int main(string[] args)
{
    //auto sn = readln.to!int;
    auto sn = args[1].to!int;

    auto nx = 300, ny = 300;
    auto field = new long[][](ny + 1, nx + 1);

    // fill field
    for (int y = 1; y <= ny; y++)
    {
        for (int x = 1; x <= nx; x++)
        {
            long rackid = x + 10;
            long pl = rackid * y;
            pl += sn;
            pl *= rackid;
            pl = (pl / 100) % 10;
            pl -= 5;

            field[y][x] = pl;
        }
    }

    int kx = 3, ky = 3;
    long smax = long.min;
    int xmax, ymax;
    for (int y = 1; y <= ny - 2; y++)
    {
        for (int x = 1; x <= nx - 2; x++)
        {
            long s = 0;
            for (int i = 0; i < ky; i++)
            {
                for (int j = 0; j < kx; j++)
                {
                    s += field[y + i][x + j];
                }
            }

            if (s > smax)
            {
                smax = s;
                xmax = x;
                ymax = y;
            }
        }
    }

    writefln("%s,%s", xmax, ymax);

    return 0;
}
