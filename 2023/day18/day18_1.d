import std;

void main(string[] args)
{
    auto lines = stdin.byLineCopy
                      .map!((x){
                          char dir;
                          int dist;
                          int color;

                          x.formattedRead("%s %d (#%x)", &dir, &dist, &color);

                          return tuple(dir, dist, color);
                      }).array;

    int[][] digged;
    int[][] corners;
    int[] pos;
    pos.length = 2;
    digged ~= pos.dup;
    corners ~= pos.dup;

    enum offs = [
        'U' : [-1,  0],
        'D' : [ 1,  0],
        'L' : [ 0, -1],
        'R' : [ 0,  1],
        ];

    foreach (line; lines)
    {
        foreach (d; iota(line[1]))
        {
            pos[] += offs[line[0]][];
            digged ~= pos.dup;
        }
        corners ~= pos.dup;
    }

    auto oi = digged.map!(x => x[0]).minElement;
    auto ni = digged.map!(x => x[0]).maxElement;

    auto oj = digged.map!(x => x[1]).minElement;
    auto mj = digged.map!(x => x[1]).maxElement;

    int n = ni - oi + 1, m = mj - oj + 1;
    char[][] field = new char[][](n, m);
    foreach (i; 0..n)
        foreach (j; 0..m)
            field[i][j] = '.';

    foreach (f; digged)
        field[f[0] - oi][f[1] - oj] = '#';

    foreach (f; corners)
        field[f[0] - oi][f[1] - oj] = 'x';

    // reuse day10
    foreach (i; iota(n))
    {
        int k = 0;
        for (int j = 0; j < m; j++)
        {
            if (field[i][j] == '#')
            {
                k = 1 - k;
            }
            else if (field[i][j] == 'x')
            {
                bool oup = (i > 1) && (field[i - 1][j] == '#');
                j++;
                while (field[i][j] == '#')
                    j++;

                bool nup = (i > 1) && (field[i - 1][j] == '#');
                if (oup ^ nup)
                    k = 1 - k;
            }
            else if (k == 1)
            {
                field[i][j] = 'o';
            }
        }
    }

    debug {
        field.join('\n').writeln;
    }
    field.joiner.filter!(x => x != '.').count.writeln;
}
