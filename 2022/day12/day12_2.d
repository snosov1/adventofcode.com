import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;

void main(string[] args)
{
    auto input = stdin.byLine;
    int N = input.front.length, M = 0;
    int[] field;

    int sm, sn, em, en;
    foreach (ref i; input)
    {
        field.length += N;

        auto sr = i.find('S');
        if (!sr.empty)
        {
            sm = M;
            sn = i.length - sr.length;
            i[sn] = 'a';
        }

        auto er = i.find('E');
        if (!er.empty)
        {
            em = M;
            en = i.length - er.length;
            i[en] = 'z';
        }

        i.copy(field[$-N..$]);
        M++;
    }

    int shortest = M*N+1;
    foreach (m; 0..M)
    {
        foreach (n; 0..N)
        {
            if (field[m * N + n] != 'a')
            {
                continue;
            }

            sm = m;
            sn = n;

            int[] visited;
            visited.length = field.length;
            int[][] queue;

            visited[sm * N + sn] = 1;
            queue ~= [sm, sn];
            while (queue.length > 0)
            {
                auto curr = queue.front;
                queue.popFront;

                foreach (off; [[-1, 0], [1, 0], [0, -1], [0, 1]])
                {
                    auto t = curr.dup;
                    t[] += off[];
                    if (t[0] >= 0 && t[0] < M && t[1] >= 0 && t[1] < N &&
                    field[t[0] * N + t[1]] - field[curr[0] * N + curr[1]] <= 1 &&
                    visited[t[0] * N + t[1]] == 0)
                    {
                        queue ~= t;
                        visited[t[0] * N + t[1]] = visited[curr[0] * N + curr[1]] + 1;
                    }
                }

                if (visited[em * N + en] > 0)
                {
                    shortest = min(shortest, visited[em * N + en] - 1);
                    break;
                }
            }
        }
    }

    writeln(shortest);
}
