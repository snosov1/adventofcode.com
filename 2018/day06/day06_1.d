// Solution seems to be a bit overcomplicated, but, frankly, I'm not sure if it
// can be much simpler

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

    auto field = new Mark[][](nx, ny);
    auto queue = zip(input, iota(cast(int)input.length)).array;
    typeof(queue) next_queue;
    int step = 1;

    auto isBound = new bool[][](input.length, 4);
    for (int i = 0; i < input.length; i++)
    {
        for (int j = i + 1; j < input.length; j++)
        {
            debug writeln(i, ":", input[i], " ", j, ":", input[j]);

            auto dist = [abs(input[i][0] - input[j][0]),
                         abs(input[i][1] - input[j][1])];

            if (dist[0] == dist[1])
                continue;

            auto idx = dist.maxIndex;

            assert(input[i][idx] != input[j][idx]);
            if (input[i][idx] < input[j][idx])
            {
                isBound[i][idx + 2] = true;
                isBound[j][idx    ] = true;
            }
            else
            {
                isBound[i][idx    ] = true;
                isBound[j][idx + 2] = true;
            }

            debug
            {
                for (int jj = 0; jj < isBound.length; jj++)
                {
                    for (int ii = 0; ii < 4; ii++)
                        write(isBound[jj][ii] ? 1 : 0);
                    writeln;
                }
            }
        }
    }

    debug writeln("equality");
    for (int i = 0; i < input.length; i++)
    {
        for (int j = i + 1; j < input.length; j++)
        {

            auto dist = [abs(input[i][0] - input[j][0]),
                         abs(input[i][1] - input[j][1])];

            if (dist[0] == dist[1])
            {
                debug writeln(i, ":", input[i], " ", j, ":", input[j]);

                if (input[i][0] < input[j][0] && input[i][1] < input[j][1])
                {
                    if (isBound[i][0])
                        isBound[i][3] = true;
                    if (isBound[i][1])
                        isBound[i][2] = true;

                    if (isBound[j][3])
                        isBound[j][0] = true;
                    if (isBound[j][2])
                        isBound[j][1] = true;
                }

                if (input[i][0] < input[j][0] && input[i][1] > input[j][1])
                {
                    if (isBound[i][3])
                        isBound[i][2] = true;
                    if (isBound[i][0])
                        isBound[i][1] = true;

                    if (isBound[j][2])
                        isBound[j][3] = true;
                    if (isBound[j][1])
                        isBound[j][0] = true;
                }

                if (input[i][0] > input[j][0] && input[i][1] < input[j][1])
                {
                    if (isBound[i][2])
                        isBound[i][3] = true;
                    if (isBound[i][1])
                        isBound[i][0] = true;

                    if (isBound[j][3])
                        isBound[j][2] = true;
                    if (isBound[j][0])
                        isBound[j][1] = true;
                }

                if (input[i][0] > input[j][0] && input[i][1] > input[j][1])
                {
                    if (isBound[i][3])
                        isBound[i][0] = true;
                    if (isBound[i][2])
                        isBound[i][1] = true;

                    if (isBound[j][0])
                        isBound[j][3] = true;
                    if (isBound[j][1])
                        isBound[j][2] = true;
                }

                debug
                {
                    for (int jj = 0; jj < isBound.length; jj++)
                    {
                        for (int ii = 0; ii < 4; ii++)
                            write(isBound[jj][ii] ? 1 : 0);
                        writeln;
                    }
                }
            }
        }
    }

    while (queue.length > 0)
    {
        debug
        {
            writeln("field:");
            outputField(field, nx, ny);
        }

        next_queue.length = 0;
        for (int i = 0; i < queue.length; i++)
        {
            auto x  = queue[i][0][0];
            auto y  = queue[i][0][1];
            auto id = queue[i][1];

            if (field[x][y].id >= 0)
            {
                if (field[x][y].id == id)
                    continue;

                //writeln(x, " ", y, " ", field[x][y].step, " ", step, " ", field[x][y].id, " ", id);
                //assert(field[x][y].step == step);
                if (field[x][y].step == step)
                    field[x][y].id = -2;
                else
                    continue;
            }

            if (field[x][y].id != -2)
            {
                field[x][y].id   = id;
                field[x][y].step = step;
            }

            if (x > 0      && field[x - 1][y    ].id == -1) next_queue ~= tuple([x - 1, y    ], id);
            if (y > 0      && field[x    ][y - 1].id == -1) next_queue ~= tuple([x    , y - 1], id);
            if (x < nx - 1 && field[x + 1][y    ].id == -1) next_queue ~= tuple([x + 1, y    ], id);
            if (y < ny - 1 && field[x    ][y + 1].id == -1) next_queue ~= tuple([x    , y + 1], id);
        }

        step++;
        queue.length = next_queue.length;
        next_queue.copy(queue);
    }

    debug
    {
        writeln("field:");
        outputField(field, nx, ny);
    }

    int m = -1;
    for (int i = 0; i < input.length; i++)
    {
        if (all!"a"(isBound[i]))
        {
            int l = cast(int)field.join
                                  .filter!(a => a.id == i)
                                  .array
                                  .length;

            if (l > m)
                m = l;
        }
    }
    writeln(m);
}
