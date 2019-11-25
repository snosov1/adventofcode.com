import std.stdio;
import std.algorithm;
import std.range;
import std.array;
import std.conv;

int main(string[] args)
{
    int d[100][100];
    fill(d[], 0xFFFFFF);
    int m = 0;

    int [string] vertices;
    int n = 0;

    foreach (line; stdin.byLine)
    {
        auto r = line.findSplit(" = ");
        auto q = r[0].findSplit(" to ");

        {
            int *p = q[0] in vertices;
            if (p is null)
                vertices[q[0].to!string] = n++;
        }
        {
            int *p = q[2] in vertices;
            if (p is null)
                vertices[q[2].to!string] = n++;
        }

        d[vertices[q[0]]][vertices[q[2]]] = r[2].to!int;
        d[vertices[q[2]]][vertices[q[0]]] = r[2].to!int;
    }

    // for (size_t i = 0; i < n; i++)
    // {
    //     for (size_t j = 0; j < n; j++)
    //     {
    //         write(d[i][j], " ");
    //     }
    //     writeln;
    // }

    auto p = iota(n).array;
    do
    {
        int l = 0;
        for (size_t i = 0; i < p.length - 1; i++)
        {
            l += d[p[i]][p[i+1]];
        }

        m = max(m, l);
    }
    while (p.nextPermutation);

    writeln(m);

    // for (int k=0; k<n; ++k)
    //     for (int i=0; i<n; ++i)
    //         for (int j=0; j<n; ++j)
    //         {
    //             d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
    //         }

    return 0;
}
