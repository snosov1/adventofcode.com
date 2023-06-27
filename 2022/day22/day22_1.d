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

    int pivot = 20;
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
                //spawnShell("ping -n 5 127.0.0.1").wait;
                //writeln("pivot", pivot);
                if (pivot == 0)
                    spawnShell("start /wait timeout /t -1").wait;
            }
        }
        if (pivot == 0)
            show();

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
                    show();

                    npos[1] = 0;
                    while (npos[0] >= field[npos[1]].length || field[npos[1]][npos[0]] == ' ')
                        npos[1]++;
                }
                else if (npos[1] == -1 || (off[f][1] < 0 && (npos[0] >= field[npos[1]].length || field[npos[1]][npos[0]] == ' ')))
                {
                    show();

                    npos[1] = field.length - 1;
                    while (npos[0] >= field[npos[1]].length || field[npos[1]][npos[0]] == ' ')
                        npos[1]--;
                }
                else if (npos[0] == field[npos[1]].length || (off[f][0] > 0 && field[npos[1]][npos[0]] == ' '))
                {
                    show();

                    npos[0] = 0;
                    while (field[npos[1]][npos[0]] == ' ')
                        npos[0]++;
                }
                else if (npos[0] == -1 || (off[f][0] < 0 && field[npos[1]][npos[0]] == ' '))
                {
                    show();

                    npos[0] = field[npos[1]].length - 1;
                    while (field[npos[1]][npos[0]] == ' ')
                        npos[0]--;
                }

                debug writeln(pos, " ", npos, " ", display_f[f]);
                if (field[npos[1]][npos[0]] == '.')
                    pos[] = npos[];
                else
                    break;
            }
        }
    }

    display[pos[1]][pos[0]] = '*';
    writeln(display.join("\n"));
    writeln(pos);

    pos[] += [1, 1];

    writeln(pos[1] * 1000 + pos[0] * 4 + f);

    // suspicious - after R7L18 goes R1 - need to check
    // 89224 -- correct!
    // 145248 -- too high
    // 167048 -- too high
}
