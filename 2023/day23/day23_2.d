import std;

int toint(int i, int j) {return i * 1000 + j;}
int toint(int[] p) {return p[0] * 1000 + p[1];}
int toint(Tuple!(int, int) p) {return p[0] * 1000 + p[1];}
int[] toc(int i) {return [i / 1000, i % 1000];}
void toc(int i, int[] c) {c.length = 2; c[0] = i / 1000; c[1] = i % 1000;}


void main(string[] args)
{
    char[][] field = stdin.byLineCopy.map!(to!(char[])).array;
    int n = field.length, m = field.front.length;

    int si = 0, sj = 1;
    int ei = n-1, ej = m-2;

    enum offs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

    int[][] graph;

    auto nodes =
    iota(n).cartesianProduct(iota(m))
           .filter!(x => field[x[0]][x[1]] != '#')
           .filter!(x => offs.filter!(off => x[0] + off[0] >= 0 &&
                                             x[1] + off[1] >= 0 &&
                                             x[0] + off[0] < n &&
                                             x[1] + off[1] < m &&
                                             field[x[0] + off[0]][x[1] + off[1]] != '#')
                             .walkLength > 2)
           .map!(toint)
           .array;

    nodes ~= toint(si, sj);
    nodes ~= toint(ei, ej);

    nodes.length.writeln;
    nodes.writeln;

    // void dfs(int i, int j)
    // {
    //     if (i == e[0] && j == e[1])
    //         return;

    //     if (visited[i * m + j] == 'g')
    //     {
    //         writeln("topological sort is impossible");
    //         return;
    //     }

    //     if (visited[i * m + j] == 'w')
    //     {
    //         visited[i * m + j] = 'g';
    //         auto dirs = offs.filter!(off => i + off[0] >= 0 && j + off[1] >= 0 &&
    //                                         i + off[0] < n && j + off[1] < m &&
    //                                         field[i + off[0]][j + off[1]] != '#' &&
    //                                         visited[(i + off[0]) * m + j + off[1]] != 'g');

    //         foreach (off; dirs)
    //         {
    //             dfs(i + off[0], j + off[1]);
    //             visited[(i + off[0]) * m + j + off[1]] = 'b';
    //             top ~= [i + off[0], j + off[1]];
    //         }
    //     }
    // }

    // dfs(si, sj);

    // foreach (p; top.retro)
    // {
    //     field[p[0]][p[1]] = 'O';

    //     foreach (row; field)
    //         row.writeln;

    //     stdout.flush();
    //     Thread.sleep(200.dur!"msecs");
    // }
    //top.writeln;
}
