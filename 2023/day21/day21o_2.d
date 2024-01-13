import std;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    int n = field.length, m = field.front.length;

    char[][] display;
    foreach (row; field)
        display ~= row.dup;

    int si = n - field.find!(x => x.canFind("S")).length;
    int sj = m - field[si].find("S").length;
    //auto s = [si, sj];

    auto s = [si, sj];

    int[] dist;
    dist.length = n*m;
    dist[] = -1;
    dist[si * m + sj] = 0;

    int[][] queue;
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
                field[c[0]][c[1]] != '#' &&
                dist[c[0] * m + c[1]] < 0)
            {
                queue ~= c.dup;
                dist[c[0] * m + c[1]] = dist[curr[0] * m + curr[1]] + 1;
            }
        }
    }

    debug {
        foreach (row; dist.chunks(m))
            row.map!(x => x == -1 ? '#' : (x + '0').to!char).writeln;
    }

    //enum nsteps = 26501356;
    //int nsteps = 6;
    int nsteps = 10;
    //int nsteps = 50;

    enum offs  = [
        [ 0, -1, -1,  1],
        [-1,  0,  1,  1],
        [ 0,  1,  1, -1],
        [ 1,  0, -1, -1]
        ];

    long ans = 0;
    foreach (o; offs)
    {
        foreach (step; 1..nsteps+1)
        {
            ans +=
            iota(0, step).map!(k =>
            tuple(
                mod(si + o[0] * step + o[2] * k, n),
                mod(sj + o[1] * step + o[3] * k, m),
                dist[mod(si + o[0] * step + o[2] * k, n) * m + mod(sj + o[1] * step + o[3] * k, m)]))
                         .filter!(x => x[2] != -1 && x[2] <= nsteps ) // last conjunction is wrong
                         .filter!(x => x[2] % 2 == nsteps % 2)
                         .count
                         //.writeln
            ;
        }

        debug {
            foreach (row; display)
                row.writeln;
        }
    }

    writeln(ans + 1 - nsteps % 2);
}
