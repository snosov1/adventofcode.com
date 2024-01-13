import std;

void main(string[] args)
{
    char[string] mods;
    string[][string] cons;
    int[string] state;
    int[string][string] conj;

    foreach (line; stdin.byLineCopy)
    {
        auto f = line.findSplit(" -> ");
        char type = 'u';
        if ("%&".any!(x => x == f[0][0]))
        {
            type = f[0][0];
            f[0].popFront;
        }

        mods[f[0]] = type;
        cons[f[0]] = f[2].split(", ").array;
        state[f[0]] = 0;

        foreach (m; cons[f[0]])
        {
            if (m !in mods)
            {
                mods[m] = 'u';
                cons[m] = new string[](0);
            }
        }
    }

    foreach (mod; mods.keys)
    {
        foreach (c; cons[mod].filter!(x => x in mods && mods[x] == '&'))
        {
            if (c !in conj)
            {
                conj[c] = [mod : 0];
            }
            else
            {
                conj[c][mod] = conj[c].length;
            }
        }
    }

    T assignBit(T)(T n, T p, T b)
    {
        T mask = 1 << p;
        return ((n & ~mask) | (b << p));
    }

    long[] n;
    n.length = 2;
    foreach (T; 0..1000)
    {
        Tuple!(string, int, string)[] queue;
        queue ~= tuple("broadcaster", 0, "button");
        n[0]++;
        while (!queue.empty)
        {
            debug {
                writeln("queue = ");
                queue.each!(x => writeln("  ", x[2], " -", x[1] ? "high" : "low", "-> ", x[0]));
                writeln("state = ", state);
            }
            auto sig = queue.front;
            queue.popFront;
            auto type = mods[sig[0]];

            if (type == 'u')
            {
                foreach (con; cons[sig[0]])
                {
                    queue ~= tuple(con, sig[1], sig[0]);
                    n[sig[1]]++;
                }
            }
            else if (type == '%')
            {
                if (sig[1] == 0)
                {
                    state[sig[0]] = 1 - state[sig[0]];
                    foreach (con; cons[sig[0]])
                    {
                        queue ~= tuple(con, state[sig[0]], sig[0]);
                        n[state[sig[0]]]++;
                    }
                }
            }
            else if (type == '&')
            {
                state[sig[0]] = assignBit(state[sig[0]], conj[sig[0]][sig[2]], sig[1]);
                int pulse = state[sig[0]] != ((1 << conj[sig[0]].length) - 1);
                foreach (con; cons[sig[0]])
                {
                    queue ~= tuple(con, pulse, sig[0]);
                    n[pulse]++;
                }
            }
            else
                assert(0);

        }
    }

    writeln(n[0] * n[1]);
}
