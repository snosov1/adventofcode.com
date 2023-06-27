import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{
    auto input = stdin.byLine;
    int N = input.front.length;
    int[][] field;
    foreach (ref i; input)
    {
        auto row = new int[N];
        i.map!(x => x.to!int - '0').copy(row);
        field ~= row;
    }
    int M = field.length;
    auto visible = new int[][M];
    foreach (i; 0..M)
        visible[i] = new int[N];

    foreach (j; 0..N)
    {
        int m = -1;
        foreach (i; 0..M)
        {
            if (field[i][j] > m)
            {
                m = field[i][j];
                visible[i][j] = 1;
            }
        }
    }

    foreach (j; 0..N)
    {
        int m = -1;

        foreach (i; iota(M-1, -1, -1))
        {
            if (field[i][j] > m)
            {
                m = field[i][j];
                visible[i][j] = 1;
            }
        }
    }

    foreach (i; 0..M)
    {
        int m = -1;
        foreach (j; iota(N-1, -1, -1))
        {
            if (field[i][j] > m)
            {
                m = field[i][j];
                visible[i][j] = 1;
            }
        }
    }

    foreach (i; 0..M)
    {
        int m = -1;
        foreach (j; 0..N)
        {
            if (field[i][j] > m)
            {
                m = field[i][j];
                visible[i][j] = 1;
            }
        }
    }

    writeln(visible.join.sum);
    //foreach (r; visible) r.writeln;

}
