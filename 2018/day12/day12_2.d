import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.utf;
import std.typecons;
import std.math;

int main(string[] args)
{
    auto state = readln.dup["initial state: ".length .. $-1];
    readln;
    auto rules = stdin.byLine
                      .map!(a => a.to!string)
                      .map!(a => tuple(a[0..5], a[$-1]))
                      .array;

    int nsteps = 200;  // that's the point in time when the changes start to
                       // only "move" the plants to the right by 1
    auto target_step = 50_000_000_000L;
    int rn = cast(int)rules.front[0].length;
    int off = nsteps + rn;
    auto filler = repeat('.', off).to!string;
    state = filler ~ state ~ filler;
    char[] newstate;
    newstate.length = state.length;

    int ws  = 5;
    int ws2 = ws / 2;

    for (int step = 0; step < nsteps; step++)
    {
        debug writefln("%2d: %s", step, state);

        newstate[] = '.';
        foreach (i, w; state.slide(ws).map!(a => a.to!string).enumerate)
        {
            foreach (rule; rules)
            {
                if (w == rule[0])
                {
                    newstate[ws2 + i] = rule[1];
                }
            }
        }

        newstate.copy(state);
    }

    debug writefln("%2d: %s", nsteps, state);

    auto idxs = zip(iota(-off, cast(int)state.length - off), state)
    .filter!(a => a[1] == '#')
    .map!(a => a[0]);

    writeln(idxs.sum + idxs.count * (target_step - nsteps));

    return 0;
}
