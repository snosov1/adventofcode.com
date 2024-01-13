import std;

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

    queue ~= s;
    int[][] nqueue;
    foreach (T; 0..64)
    {
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
                field[c[0]][c[1]] != '#' // &&
                // dist[c[0] * m + c[1]] < 0
                    )
                {
                    nqueue ~= c.dup;
                    dist[c[0] * m + c[1]] = dist[curr[0] * m + curr[1]] + 1;
                }
            }
        }
        queue = nqueue;
        nqueue.length = 0;
    }

    debug {
        foreach (row; dist.chunks(m))
            row.writeln;
    }

    dist.maxCount[1].writeln;
}
