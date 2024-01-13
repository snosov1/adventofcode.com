import std;

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    int n = field.length;
    int m = field.front.length;
    int[][][] energy;
    energy.length = n;
    foreach (ref row; energy)
        row.length = m;

    enum toint = [
        [ 0,  1] : 1,
        [ 0, -1] : 2,
        [ 1,  0] : 3,
        [-1,  0] : 4,
        ];

    enum toarr = [
        1 : [ 0,  1],
        2 : [ 0, -1],
        3 : [ 1,  0],
        4 : [-1,  0],
        ];

    void follow(int[] o, int[] d)
    {
        debug {
            writeln(o, " ", d);
            //energy.map!(x => x.map!(y => !y.empty ? '#' : '.')).join('\n').writeln;
            writeln(energy.map!(x => x.count!(y => !y.empty)).sum);

            // foreach (i; iota(n))
            // {
            //     foreach (j; iota(m))
            //         if (energy[i][j].length > 3)
            //             writeln(energy[i][j]);
            // }


            // foreach (i; iota(n))
            // {
            //     foreach (j; iota(m))
            //         write(i == o[0] && j == o[1] ? '*' : energy[i][j].empty ? '.' : '#');
            //     writeln;
            // }
        }
        if (o[0] < 0 || o[0] >= n || o[1] < 0 || o[1] >= m || energy[o[0]][o[1]].canFind(toint[d]))
            return;

        energy[o[0]][o[1]] ~= toint[d];

        auto c = field[o[0]][o[1]];
        if (c == '.' || (d[0] == 0 && c == '-') || (d[1] == 0 && c == '|'))
        {

        }
        else if (c == '\\')
        {
            swap(d[0], d[1]);
        }
        else if (c == '/')
        {
            swap(d[0], d[1]);
            d[] = -d[];
        }
        else if (d[0] == 0 && c == '|')
        {
            d[] = [1, 0];
            follow([o[0] - 1, o[1]], [-1, 0]);
        }
        else if (d[1] == 0 && c == '-')
        {
            d[] = [0, 1];
            follow([o[0], o[1] - 1], [0, -1]);
        }
        else
        {
            assert(0);
        }

        o[] += d[];
        follow(o, d);
    }

    int[] sums;
    foreach (sj; iota(m))
    {
        follow([0, sj], [1, 0]);
        sums ~= energy.map!(x => x.count!(y => !y.empty)).sum;
        debug {
            energy.map!(x => x.map!(y => !y.empty ? '#' : '.')).join('\n').writeln;
            writeln;
        }
        foreach (i; iota(n)) foreach (j; iota(m)) energy[i][j].length = 0;

        follow([n-1, sj], [-1, 0]);
        sums ~= energy.map!(x => x.count!(y => !y.empty)).sum;
        foreach (i; iota(n)) foreach (j; iota(m)) energy[i][j].length = 0;
    }

    foreach (si; iota(n))
    {
        follow([si, 0], [0, 1]);
        sums ~= energy.map!(x => x.count!(y => !y.empty)).sum;
        foreach (i; iota(n)) foreach (j; iota(m)) energy[i][j].length = 0;

        follow([si, m-1], [0, -1]);
        sums ~= energy.map!(x => x.count!(y => !y.empty)).sum;
        foreach (i; iota(n)) foreach (j; iota(m)) energy[i][j].length = 0;
    }

    sums.maxElement.writeln;
}
