import std.stdio;
import std.algorithm;
import std.range;
import std.array;
import std.conv;

int main(string[] args)
{
    int d[100][100];
    fill(d[], 0);
    int m = 0;

    int [string] vertices;
    int n = 0;

    foreach (line; stdin.byLine)
    {
        auto r = line.findSplit(" would ");
        auto q = r[2].findSplit(" happiness units by sitting next to ");
        q[2].length--;

        {
            int *p = r[0] in vertices;
            if (p is null)
                vertices[r[0].to!string] = n++;
        }
        {
            int *p = q[2] in vertices;
            if (p is null)
                vertices[q[2].to!string] = n++;
        }

        int hap = 0;
        if (q[0][0] == 'g')
        {
            hap = 1;
        }
        else
        {
            hap = -1;
        }
        q[0] = q[0][5..$];

        d[vertices[r[0]]][vertices[q[2]]] = hap * q[0].to!int;
    }

    n++; // 2 stars (add yourself)

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
        int hap = 0;
        for (int i = 0; i < p.length; i++)
        {
            int l = i - 1;
            if (l < 0)
                l = cast(int)(p.length) - 1;
            int r = i + 1;
            if (r == p.length)
                r = 0;

            hap += d[ p[i] ][ p[l] ];
            hap += d[ p[i] ][ p[r] ];
        }

        m = max(m, hap);
    }
    while (p.nextPermutation);

    writeln(m);

    return 0;
}
