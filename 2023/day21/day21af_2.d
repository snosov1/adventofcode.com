import std;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

int div(int x, int m)
{
    int r = mod(x, m);

    if (x >= 0)
        return (x - r) / m;

    return (- x - 1 + m) / m;
}

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;

    foreach (ref row; field)
        row = row.repeat(3).join.idup;
    field ~= field.repeat(2).join;
    int n = field.length, m = field.front.length;

    char[][] display;
    foreach (row; field)
        display ~= row.dup;

    int si = n - field.find!(x => x.canFind("S")).length;
    int sj = m - field[si].find("S").length;

    si += n / 3;
    sj += m / 3;

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
                         .filter!(x => x[2] != -1 && x[2] <= nsteps)
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

// fuck my ass
// (div(si + o[0] * step + o[2] * k, n) + div(sj + o[1] * step + o[3] * k, m)) * dist[(mod(mod(si + o[0] * step + o[2] * k, n), n/3) + n/3 + (o[0] == 0 ? o[2] : -o[2]) * n/3) * m + (mod(mod(sj + o[1] * step + o[3] * k, m), m/3) + m/3 + (o[1] == 0 ? o[3] : -o[3]) * m/3)] - dist[(mod(mod(si + o[0] * step + o[2] * k, n), n/3) + n/3) * m + (mod(mod(sj + o[1] * step + o[3] * k, m), m/3) + m/3)]))

// dist[(mod(x[0], n/3) + n/3 + (o[0] == 0 ? o[2] : -o[2]) * n/3) * m + (mod(x[1], m/3) + m/3 + (o[1] == 0 ? o[3] : -o[3]) * m/3)] - dist[(mod(x[0], n/3) + n/3) * m + (mod(x[1], m/3) + m/3)]
