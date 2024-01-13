import std;

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    auto reg = regex(`(.*?)(^|O|#)(\.+?)O(.*)`);
    string[] rot;

    void eval()
    {
        string[] res;
        foreach (line; rot)
        {
            auto row = line.to!string;
            while(true)
            {
                auto rep = row.replaceFirst(reg, "$1$2O$3$4");
                if (rep.empty || rep == row)
                    break;
                row = rep;
            }
            res ~= row;
        }
        rot = res;
    }

    int[] loads;
    foreach (i; iota(300))
    {
        debug {
            writeln("Cycle ", i+1);
            field.join('\n').writeln;
        }
        // north
        foreach (line; field.transposed)
            rot ~= line.map!(to!char).array;
        debug {
            writeln;
            rot.join('\n').writeln;
        }
        int load = rot.map!(row => row.enumerate.map!(x => (row.length - x[0]) * (x[1] == 'O')).sum).sum;
        // if (loads.canFind(load))
        // {
        //     writeln(loads.length);
        //     return;
        // }
        loads ~= load;
        eval();

        // west
        field = rot;
        rot.length = 0;
        foreach (line; field.transposed)
            rot ~= line.map!(to!char).array;
        debug {
            writeln;
            rot.join('\n').writeln;
        }
        eval();

        // south
        field = rot;
        rot.length = 0;
        foreach (line; field.reverse.transposed)
            rot ~= line.map!(to!char).array;
        debug {
            writeln;
            rot.join('\n').writeln;
        }
        eval();

        // east
        field = rot;
        rot.length = 0;
        foreach (line; field.transposed)
            rot ~= line.array.retro.map!(to!char).array;
        rot.reverse;
        debug {
            writeln;
            rot.join('\n').writeln;
        }
        eval();

        // reset
        field.length = 0;
        foreach (line; rot)
            field ~= line.array.retro.map!(to!char).array;
        rot.length = 0;
        debug {
            writeln;
            field.join('\n').writeln;
        }
    }

    // the cycle was found manually

    // // test
    // int idx = 3 + (1_000_000_000 - 3) % 7;
    // loads[idx].writeln;

    // in
    int idx = 117 + (1_000_000_000 - 117) % 42;
    loads[idx].writeln;
}
