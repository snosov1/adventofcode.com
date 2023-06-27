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

    auto non_zero_valves = graph.keys.filter!(k => graph[k].rate != 0)
                                .map!(x => indicies[x]);

    int go(int curr, int[] open, int minutes, bool elephant)
    {
        int m = 0;
        bool found = false;
        foreach (i; 0..N)
        {
            int d = adjacency[curr][i] + 1;
            if (d >= minutes || open[i] != 0)
                continue;

            found = true;
            int o = rates[i] * (minutes - d);

            auto nopen = open.dup;
            nopen[i] = 1;
            o += go(i, nopen, minutes - d, elephant);

            if (o > m)
                m = o;
        }

        if (!found && elephant)
            return go(indicies["AA"], open, 26, false);

        return m;
    }

    int[] open;
    open.length = N;
    foreach (z; zero_valves)
        open[z] = 1;
    writeln(go(indicies["AA"], open, 26, true));
}
