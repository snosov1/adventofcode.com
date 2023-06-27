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

struct Valve
{
    int rate;
    string name;
    string[] pipes;
}

struct State
{
    int output;
    int[] open;
}

void main(string[] args)
{
    int N = 0;
    int[string] indicies;
    Valve[string] graph;
    int[] rates;
    foreach (line; stdin.byLine)
    {
        Valve valve;
        string pipes;
        line.formattedRead("Valve %s has flow rate=%d; %s", valve.name, valve.rate, pipes);
        valve.pipes = pipes.split(", ").array;
        valve.pipes[0] = valve.pipes[0][$-2..$];
        graph[valve.name] = valve;

        writeln(valve.name, " ", N);

        indicies[valve.name] = N++;
        rates ~= valve.rate;
    }

    //writeln(graph);

    enum static_N = 60;
    enforce(N < static_N);
    int[static_N][static_N] adjacency = 2000*N;
    foreach (i; 0..N)
        adjacency[i][i] = 0;

    foreach (k, v; graph)
    {
        int i = indicies[k];
        foreach (p; v.pipes)
        {
            int j = indicies[p];
            adjacency[i][j] = adjacency[j][i] = 1;
        }
    }

    // Floyd
    for (int k=0; k<N; ++k)
        for (int i=0; i<N; ++i)
            for (int j=0; j<N; ++j)
                adjacency[i][j] = min (adjacency[i][j], adjacency[i][k] + adjacency[k][j]);

    auto zero_valves = graph.keys.filter!(k => graph[k].rate == 0)
                            .map!(x => indicies[x]);

    State[Tuple!(int, int)] dict;

    State s;
    s.output = 0;
    s.open.length = N;
    foreach (z; zero_valves)
        s.open[z] = 1;
    auto t = tuple(indicies["AA"], 30);
    dict[t] = s;
    Tuple!(int, int)[] queue;
    queue ~= t;

    while (!queue.empty)
    {
        t = queue.front;
        queue.popFront;
        s = dict[t];

        foreach (i; 0..N)
        {
            if (s.open[i] == 0)
            {
                int d = adjacency[t[0]][i] + 1;
                int o = s.output + zip(s.open, rates).map!(x => x[0] * x[1]).sum * d;
                //writeln(i, " ", t[0], " ", s.open, " ", rates);
                //writeln(i, " ", t[0], " ", d);

                if (t[1] - d < 0)
                    break;

                auto tt = tuple(i, t[1] - d);

                State ss;
                ss.output = o;
                ss.open = s.open.dup;
                ss.open[i] = 1;

                dict.update(tt,
                () {
                    queue ~= tt;
                    return ss;
                },
                (ref State old) {
                    // int o1 = o +          zip(s  .open, rates).map!(x => x[0] * x[1]).sum * tt[1];
                    // int o2 = old.output + zip(old.open, rates).map!(x => x[0] * x[1]).sum * tt[1];
                    // if (o1 > o2)
                    if (o >= old.output)
                    {
                        old = ss;
                        queue ~= tt;
                    }
                });
            }
        }

        // writeln(queue.length);

        // writeln;
        // foreach (k, v; dict)
        // {
        //     int o = v.output + zip(v.open, rates).map!(x => x[0] * x[1]).sum * k[1];
        //     writeln(k, " ", v, " ", o);
        // }

        // writeln;
        // foreach (k, v; dict)
        // {
        //     if (k[1] == 21)
        //     {
        //         int o = v.output + zip(v.open, rates).map!(x => x[0] * x[1]).sum * k[1];
        //         writeln(k, " ", v, " ", o);
        //     }
        // }
    }



    // writeln;
    // foreach (k, v; dict)
    // {
    //     int o = v.output + zip(v.open, rates).map!(x => x[0] * x[1]).sum * k[1];
    //     writeln(k, " ", v, " ", o);
    // }

    int m = 0;
    // writeln;
    foreach (k, v; dict)
    {
        int o = v.output + zip(v.open, rates).map!(x => x[0] * x[1]).sum * k[1];
        if (o > m)
            m = o;
    }
    writeln(m);
}
