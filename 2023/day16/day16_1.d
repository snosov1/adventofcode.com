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
            energy.map!(x => x.map!(y => y ? '#' : '.')).join('\n').writeln;
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
            d[] = [d[1], d[0]];
        }
        else if (c == '/')
        {
            d[] = [-d[1], -d[0]];
        }
        else if (d[0] == 0 && c == '|')
        {
            d[] = [1, 0];

            int[] on = o.dup;
            on[] += [-1, 0];
            follow(on, [-1, 0]);
        }
        else if (d[1] == 0 && c == '-')
        {
            d[] = [0, 1];

            int[] on = o.dup;
            on[] += [0, -1];
            follow(on, [0, -1]);
        }

        o[] += d[];
        follow(o, d);
    }

    follow([0, 0], [0, 1]);
    debug {
        energy.map!(x => x.map!(y => !y.empty ? '#' : '.')).join('\n').writeln;
    }

    energy.map!(x => x.count!(y => !y.empty))
          .sum
          .writeln;
}
