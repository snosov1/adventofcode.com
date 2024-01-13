import std;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

void main(string[] args)
{
    string[] field = stdin.byLineCopy.array;
    int n = field.length, m = field.front.length;

    char[][] display;
    foreach (row; field)
        display ~= row.dup;

    int si = n - field.find!(x => x.canFind("S")).length;
    int sj = m - field[si].find("S").length;
    //auto s = [si, sj];

    //enum nsteps = 26501356;
    int nsteps = 6;
    long[] line;
    long[] nline;
    line.length = nsteps+1;
    nline.length = line.length;

    enum offs  = [
        [ 0, -1, -1,  1],
        [-1,  0,  1,  1],
        [ 0,  1,  1, -1],
        [ 1,  0, -1, -1]
        ];

    long ans = 0;
    foreach (o; offs)
    {
        line[0] = 1;
        foreach (s; 1..nsteps+1)
        {
            nline[] = 0;
            foreach (k; iota(0, s + 1))
            {
                int i = mod(si + o[0] * s + o[2] * k, n);
                int j = mod(sj + o[1] * s + o[3] * k, m);

                if (field[i][j] == '#')
                    continue;

                if ((k > 0 && line[k - 1] == 1) || (k < s && line[k] == 1))
                {
                    nline[k] = 1;
                    debug {
                        display[i][j] = (s + '0').to!char;
                    }
                }
            }
            nline.copy(line);
            //line.writeln;

            if (s % 2 == nsteps % 2)
                ans += line[0..s].sum;
        }

        debug {
            foreach (row; display)
                row.writeln;
        }
    }

    writeln(ans);
}
