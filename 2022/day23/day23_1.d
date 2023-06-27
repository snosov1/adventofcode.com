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

void display(int[][] elves)
{
    auto minx = elves.map!(x => x[0]).minElement;
    auto maxx = elves.map!(x => x[0]).maxElement;
    auto miny = elves.map!(x => x[1]).minElement;
    auto maxy = elves.map!(x => x[1]).maxElement;

    int N = maxx - minx + 1;
    int M = maxy - miny + 1;
    char[] field;
    field.length = N*M;
    field[] = '.';

    foreach (elf; elves)
    {
        int x = elf[0] - minx;
        int y = elf[1] - miny;

        y = M - 1 - y;

        field[y * N + x] = '#';
    }

    field.chunks(N).join('\n').writeln;
}


int main(string[] args)
{
    debug writeln("start");
    debug stdout.sync;

    auto lookup = [
        [[ 0,  1], [ 1,  1], [-1,  1]],
        [[ 0, -1], [ 1, -1], [-1, -1]],
        [[-1,  0], [-1,  1], [-1, -1]],
        [[ 1,  0], [ 1,  1], [ 1, -1]]
        ].cycle;

    auto neighbors = [
        [ 1, 0], [ 1,  1], [0,  1], [-1,  1],
        [-1, 0], [-1, -1], [0, -1], [ 1, -1]
        ];

    int[][] elves;
    foreach (y, line; stdin.byLine.enumerate)
        foreach (x, c; line.enumerate)
            if (c == '#')
                elves ~= [x, -y];

    debug elves.display;

    foreach (round; 0..10)
    {
        debug writeln("round ", round);
        int[][] proposals;
        int[] prop;
        prop.length = 2;
        foreach (elf; elves)
        {
            bool found = false;
            if (neighbors.map!(x => prop[] = elf[] + x[])
                         .any!(x => elves.canFind(x)))
                foreach (lp; lookup.take(4))
                {
                    if (lp.map!(x => prop[] = elf[] + x[])
                          .all!(x => !elves.canFind(x)))
                    {
                        prop[] = elf[] + lp.front[];
                        proposals ~= prop.dup;
                        found = true;
                        break;
                    }
                }

            if (!found)
                proposals ~= elf.dup;
        }

        debug
        {
            elves.writeln;
            writeln("proposals 1 = ", proposals);
        }

        int[] indices;
        foreach (p; proposals)
        {
            indices.length = 0;
            foreach (i, p2; proposals.enumerate)
                if (p2.equal(p))
                    indices ~= i;

            if (indices.length > 1)
                foreach (i; indices)
                    proposals[i] = elves[i].dup;
        }

        debug
        {
            writeln("proposals 2 = ", proposals);
            proposals.display;
            writeln;
        }

        proposals.copy(elves);
        proposals.length = 0;
        lookup.popFront;
    }

    auto minx = elves.map!(x => x[0]).minElement;
    auto maxx = elves.map!(x => x[0]).maxElement;
    auto miny = elves.map!(x => x[1]).minElement;
    auto maxy = elves.map!(x => x[1]).maxElement;

    writeln((maxx - minx + 1) * (maxy - miny + 1) - elves.length);

    return 0;
}
