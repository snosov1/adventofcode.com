import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;
import std.typecons;
import std.numeric;

void main(string[] args)
{
    char[][] field = stdin.byLineCopy.map!(x => x.to!(char[])).array;
    int n = field.length, m = field.front.length;

    int[][] queue;

    int si = n - field.find!(x => x.canFind("S")).length;
    int sj = m - field[si].find("S").length;
    auto s = [si, sj];

    int[] dist;
    dist.length = n*m;
    dist[] = -1;
    dist[si * m + sj] = 0;

    auto con = [
        [-1,  0]: ["|LJS", "|7F"],
        [ 1,  0]: ["|7FS", "|LJ"],
        [ 0,  1]: ["-LFS", "-7J"],
        [ 0, -1]: ["-7JS", "-LF"],
        ];

    queue ~= s;
    while (!queue.empty)
    {
        auto curr = queue.front;
        queue.popFront;

        foreach (off; [[1, 0], [-1, 0], [0, 1], [0, -1]])
        {
            int[2] c;
            c[] = curr[] + off[];
            if (c[0] >= 0 && c[1] >= 0 && c[0] < n && c[1] < m &&
                con[off][0].canFind(field[curr[0]][curr[1]]) &&
                con[off][1].canFind(field[c[0]][c[1]]) &&
                dist[c[0] * m + c[1]] < 0)
            {
                queue ~= c.dup;
                dist[c[0] * m + c[1]] = dist[curr[0] * m + curr[1]] + 1;
            }
        }
    }

    debug {
        foreach (row; dist.chunks(m))
            row.writeln;
    }

    // manually set for my input
    field[si][sj] = 'L';

    int ans = 0;
    foreach (i; iota(n))
    {
        int k = 0;
        for (int j = 0; j < m; j++)
        {
            if (dist[i * m + j] >= 0 && field[i][j] == '|')
            {
                k = 1 - k;
            }
            else if (dist[i * m + j] >= 0 && "LF".canFind(field[i][j]))
            {
                char open = field[i][j];
                j++;
                while (dist[i * m + j] >= 0 && "-".canFind(field[i][j]))
                    j++;

                if ((open == 'L' && field[i][j] == '7') || (open == 'F' && field[i][j] == 'J'))
                    k = 1 -k;
            }
            else if (k == 1 && dist[i * m + j] < 0)
            {
                ans++;
                field[i][j] = 'I';
            }
        }
    }

    ans.writeln;

    debug {
        field.join('\n').writeln;
    }
}
