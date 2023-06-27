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
import std.numeric;
import std.ascii;
import std.process;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

int convert(int[] pos, int[] npos, int src_face, int f)
{
    //writeln("src = ", src_face);

    if (src_face == 1)
    {
        if (f == 2) // left - ok
        {
            npos[0] = 0;
            npos[1] = 100 + (49 - pos[1]);

            return 0; // right
        }
        else if (f == 3) // up - ok - validated
        {
            npos[0] = 0;
            npos[1] = 150 + (pos[0] - 50);

            return 0; // right
        }
        else
            assert(0);
    }
    else if (src_face == 2)
    {
        if (f == 2) // left - ok
        {
            npos[0] = (pos[1] - 150) + 50;
            npos[1] = 0;
            return 1; // down
        }
        else if (f == 0) // right - ok
        {
            npos[0] = (pos[1] - 150) + 50;
            npos[1] = 149;
            return 3; // up
        }
        else if (f == 1) // down - ok
        {
            npos[0] = pos[0] + 100;
            npos[1] = 0;
            return 1; // down
        }
        else
            assert(0);
    }
    else if (src_face == 3)
    {
        if (f == 2) // left - ok
        {
            npos[0] = 50;
            npos[1] = 49 - (pos[1] - 100);

            return 0; // right
        }
        else if (f == 3) // up - ok
        {
            npos[0] = 50;
            npos[1] = pos[0] + 50;

            return 0; // right
        }
        else
            assert(0);
    }
    else if (src_face == 4)
    {
        if (f == 2) // left - ok
        {
            npos[0] = pos[1] - 50;
            npos[1] = 100;

            return 1; // down
        }
        else if (f == 0) // right - ok
        {
            npos[0] = 100 + pos[1] - 50;
            npos[1] = 49;

            return 3; // up
        }
        else
            assert(0);
    }
    else if (src_face == 5)
    {
        if (f == 0) // right - ok
        {
            npos[0] = 149;
            npos[1] = 49 - (pos[1] - 100);

            return 2; // left
        }
        else if (f == 1) // down - ok
        {
            npos[0] = 49;
            npos[1] = 150 + pos[0] - 50;

            return 2; // left
        }
        else
            assert(0);
    }
    else if (src_face == 6)
    {
        if (f == 0) // right - ok
        {
            npos[0] = 99;
            npos[1] = 149 - pos[1];

            return 2; // left
        }
        else if (f == 1) // down - ok
        {
            npos[0] = 99;
            npos[1] = pos[0] - 100 + 50;

            return 2; // left
        }
        else if (f == 3) // up - ok
        {
            npos[0] = pos[0] - 100;
            npos[1] = 199;

            return 3; // up
        }
        else
            assert(0);
    }

    assert(0);
}

void main(string[] args)
{
    auto input = stdin.byLine.map!(x => x.dup).array.splitter("");

    char[][] field = input.front;
    input.popFront;
    auto route = input.front[0].splitWhen!((a, b) => a.isAlpha || b.isAlpha);

    // // extend
    // int M = field.map!(x => x.length).maxElement;
    // foreach (line; field)
    // {
    //     if (line.length < M)
    //     {
    //         int l = line.length;
    //         line.length = M;
    //         line[l..M] = ' ';
    //     }
    // }

    char[][] mask = File("in.mask").byLine.map!(x => x.dup).array;
    writeln(mask.join("\n"));

    // create display
    char[][] display;
    //display = field.length;
    foreach (line; field)
        display ~= line.dup;

    // find start
    int[] pos = [0, 0];
    while(field[pos[1]][pos[0]] != '.')
    {
        if (++pos[0] == field[pos[1]].length)
        {
            pos[0] = 0;
            pos[1]++;
        }
    }

    int f = 0;
    enum display_f = ['>', 'v', '<', '^'];
    enum off = [[1, 0], [0, 1], [-1, 0], [0, -1]];

    int[] npos;
    npos.length = 2;

    int pivot = 0;
    int old_f = f;
    foreach (move; route)
    {
        debug writeln(move);
        debug writeln(pos, " ", display_f[f]);
        void show()
        {
            if (pivot > 0)
                pivot--;
            debug
            {
                spawnShell("cls").wait;
                writeln(display.join("\n"));
                writeln(move);
                writeln(mask[pos[1]][pos[0]], " ", pos, " ", display_f[old_f], " ", npos, " ", display_f[f]);
                //spawnShell("ping -n 5 127.0.0.1").wait;
                //writeln("pivot", pivot);
                if (pivot == 0)
                    spawnShell("start /wait timeout /t -1").wait;
            }
        }
        // if (pivot == 0)
        //     show();

        if (move.front.isAlpha)
        {
            // handle rotation
            if (move.front == 'R')
                f = mod(f + 1, 4);
            else
                f = mod(f - 1, 4);

            display[pos[1]][pos[0]] = display_f[f];
        }
        else
        {

            // handle movement
            foreach (step; 0..move.to!int)
            {
                display[pos[1]][pos[0]] = display_f[f];

                npos[] = pos[] + off[f][];

                if (npos[1] == field.length || (off[f][1] > 0 && (npos[0] >= field[npos[1]].length || field[npos[1]][npos[0]] == ' ')))
                {
                    old_f = f;
                    f = convert(pos, npos, mask[pos[1]][pos[0]] - '0', f);
                    if (field[npos[1]][npos[0]] == '#')
                        f = old_f;

                    show();
                    writeln(npos ~ f);
                }
                else if (npos[1] == -1 || (off[f][1] < 0 && (npos[0] >= field[npos[1]].length || field[npos[1]][npos[0]] == ' ')))
                {
                    old_f = f;
                    f = convert(pos, npos, mask[pos[1]][pos[0]] - '0', f);
                    if (field[npos[1]][npos[0]] == '#')
                        f = old_f;

                    show();
                    writeln(npos ~ f);
                }
                else if (npos[0] == field[npos[1]].length || (off[f][0] > 0 && field[npos[1]][npos[0]] == ' '))
                {
                    old_f = f;
                    f = convert(pos, npos, mask[pos[1]][pos[0]] - '0', f);
                    if (field[npos[1]][npos[0]] == '#')
                        f = old_f;

                    show();
                    writeln(npos ~ f);
                }
                else if (npos[0] == -1 || (off[f][0] < 0 && field[npos[1]][npos[0]] == ' '))
                {
                    old_f = f;
                    f = convert(pos, npos, mask[pos[1]][pos[0]] - '0', f);
                    if (field[npos[1]][npos[0]] == '#')
                        f = old_f;

                    show();
                    writeln(npos ~ f);
                }

                if (field[npos[1]][npos[0]] == '.')
                {
                    pos[] = npos[];
                }
                else
                {
                    //f = old_f;
                    break;
                }
            }
        }
    }

    display[pos[1]][pos[0]] = '*';
    writeln(display.join("\n"));
    writeln(pos);

    pos[] += [1, 1];

    writeln(pos[1] * 1000 + pos[0] * 4 + f);

    // 9585 -- too low
    // 146037 -- too high
}
