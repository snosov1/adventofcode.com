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
    string[] field = stdin.byLineCopy.array;
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
        debug{
            writeln("queue = ", queue);
        }
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

    dist.maxElement.writeln;
}
