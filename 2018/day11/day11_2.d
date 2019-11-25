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

            field[y][x] = field[y - 1][x] + field[y][x - 1] - field[y - 1][x - 1] + pl;
        }
    }

    long smax = long.min;
    int xmax, ymax, sizemax;

    for (int size = 1; size <= min(nx, ny); size++)
    {
        for (int y = 1; y <= ny - size + 1; y++)
        {
            for (int x = 1; x <= nx - size + 1; x++)
            {
                long s = + field[y + size - 1][x + size - 1]
                         + field[y - 1]       [x - 1]
                         - field[y + size - 1][x - 1]
                         - field[y - 1]       [x + size - 1];

                if (s > smax)
                {
                    smax = s;
                    xmax = x;
                    ymax = y;
                    sizemax = size;
                }
            }
        }
    }

    writefln("%s,%s,%s", xmax, ymax, sizemax);

    return 0;
}
