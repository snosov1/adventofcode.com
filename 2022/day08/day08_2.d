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
    {
        visible[i] = new int[N];
        if (i == 0 || i == M-1)
            visible[i][] = 0;
        else
        {
            visible[i][] = 1;
            visible[i][0] = visible[i][N-1] = 0;
        }

    }

    foreach (j; 1..N-1)
    {
        foreach (i; 1..M-1)
        {
            int m = field[i][j];
            for (int x = i+1; x < M; x++)
            {
                if (field[x][j] >= m || x == M-1)
                {
                    visible[i][j] *= x - i;
                    break;
                }
            }

            for (int x = i-1; x >= 0; x--)
            {
                if (field[x][j] >= m || x == 0)
                {
                    visible[i][j] *= i - x;
                    break;
                }
            }


            for (int x = j+1; x < N; x++)
            {
                if (field[i][x] >= m || x == N-1)
                {
                    visible[i][j] *= x - j;
                    break;
                }
            }

            for (int x = j-1; x >= 0; x--)
            {
                if (field[i][x] >= m || x == 0)
                {
                    visible[i][j] *= j - x;
                    break;
                }
            }
        }
    }

    writeln(visible.join.maxElement);
    //writeln(i, " ", j);
    //foreach (r; visible) r.writeln;
}
