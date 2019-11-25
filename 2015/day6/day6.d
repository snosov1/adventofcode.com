import std.stdio;
import std.format;
import std.algorithm;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

int grid[1000][1000];

int main(string[] args)
{
    foreach (line; stdin.byLine)
    {
        int opcode;

        if (line.startsWith("turn on"))
        {
            opcode = 1;
            line = line["turn on".length + 1..$];
        }
        else if (line.startsWith("turn off"))
        {
            opcode = -1;
            line = line["turn off".length + 1..$];
        }
        else if (line.startsWith("toggle"))
        {
            opcode = 0;
            line = line["toggle".length + 1..$];
        }
        else
        {
            assert(0);
        }

        int x1, y1;
        int x2, y2;
        line.formattedRead("%d,%d through %d,%d", &x1, &y1, &x2, &y2);

        for (int i = y1; i <= y2; i++)
        {
            for (int j = x1; j <= x2; j++)
            {
                if (opcode == 1)
                    grid[i][j]++;
                else if (opcode == 0)
                    grid[i][j] += 2;
                else if (opcode == -1)
                    grid[i][j]--;

                if (grid[i][j] < 0)
                    grid[i][j] = 0;
            }
        }
    }

    int s = 0;
    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
            s += grid[i][j];
        }
    }

    writeln(s);

    return 0;
}
