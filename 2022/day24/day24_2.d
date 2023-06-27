import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;
import std.ascii;
import std.process;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

int main(string[] args)
{
    enum offs = [
        '>': [ 1,  0],
        'v': [ 0,  1],
        '<': [-1,  0],
        '^': [ 0, -1],
        ];

    auto input = stdin.byLine;
    //auto first = input.front;
    //input.popFront;

    int N, M = 0;
    int[][] blizzards;
    int start_x = 1, start_y = 0;
    int end_x, end_y;
    foreach (y, line; input.enumerate)
    {
        if (line[0..2] == "##")
        {
            N = line.length;
            M = y + 1;
            end_y = M - 1;
            end_x = line.length - line.find('.').length;
            break;
        }
        foreach (x, c; line.enumerate)
        {
            if (c.to!char in offs)
                blizzards ~= [x.to!int, y.to!int] ~ offs[c.to!char];
        }
    }

    int[][] visited;
    int[] occupied;
    visited.length = occupied.length = N*M;
    visited[start_y * N + start_x] ~= 0;

    int[][] tuples = cartesianProduct(iota(1,N-1), iota(1,M-1)).map!(x => [x[0], x[1]]).array;
    tuples ~= [start_x, start_y];
    tuples ~= [end_x, end_y];

    int nrun = 0;
    for (int T = 1; ; T++)
    {
        debug writeln("T = ", T);

        if (nrun == 0 && visited[end_y * N + end_x].length > 0)
        {
            debug writeln("reached end on step ", T);
            nrun = 1;
            foreach (ref v; visited)
                v.length = 0;
            visited[end_y * N + end_x] ~= T - 1;
        }

        if (nrun == 1 && visited[start_y * N + start_x].length > 0)
        {
            debug writeln("reached start on step ", T);
            nrun = 2;
            foreach (ref v; visited)
                v.length = 0;
            visited[start_y * N + start_x] ~= T - 1;
        }

        if (nrun == 2 && visited[end_y * N + end_x].length > 0)
        {
            debug writeln("reached end on step ", T);
            writeln(T - 1);
            return 0;
        }

        // move blizzards
        foreach (ref b; blizzards)
        {
            b[0..2] += b[2..4];

            b[0] = mod(b[0] - 1, N-2) + 1;
            b[1] = mod(b[1] - 1, M-2) + 1;
        }

        // update occupied
        occupied[] = 0;
        occupied[0..N] = 1;
        occupied[start_y * N + start_x] = 0;
        foreach (i; 1..M-1)
        {
            occupied[i * N] = 1;
            occupied[i * N + N - 1] = 1;
        }
        occupied[(M - 1) * N..(M - 1) * N + N][] = 1;
        occupied[end_y * N + end_x] = 0;
        foreach (b; blizzards)
            occupied[b[1] * N + b[0]] = 1;

        debug
        {
            // foreach (c; occupied.chunks(N))
            //     c.writeln;
        }

        int[] buf;
        buf.length = 2;
        foreach (pos; tuples)
        {
            if (occupied[pos[1] * N + pos[0]] == 0)
            {
                foreach(npos; offs.values.chain([[0, 0]])
                                  .map!(x => buf[] = x[] + pos[])
                                  .filter!(x => (x[0] == start_x && x[1] == start_y) || (x[0] == end_x && x[1] == end_y) || (x[0] > 0 && x[1] > 0 && x[0] < N-1 && x[1] < M-1)))
                {
                    if (visited[npos[1] * N + npos[0]].canFind(T-1))
                    {
                        visited[pos[1] * N + pos[0]] ~= T;
                    }
                }
            }
        }
    }

    //writeln(start_x, " ", start_y, " ", end_x, " ", end_y, " ", N, " ", M);

    return 0;
}
