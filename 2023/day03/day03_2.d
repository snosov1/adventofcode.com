import std.stdio;
import std.conv;
import std.typecons;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    string[] input = stdin.byLineCopy.array;
    int[][Tuple!(int, int)] gears;
    int n = input.length;
    int m = input.front.length;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (!input[i][j].isDigit)
                continue;

            int k = j+1;
            while (k < m && input[i][k].isDigit)
            {
                k++;
            }

            string candidates;
            if (i > 0)
                candidates ~= input[i-1][max(j-1,0)..min(k+1,m)];
            if (i < n-1)
                candidates ~= input[i+1][max(j-1,0)..min(k+1,m)];
            if (j > 0)
                candidates ~= input[i][j-1];
            if (k < m)
                candidates ~= input[i][k];

            debug {
                writeln(input[i][j..k]);
                writeln(candidates);
            }

            if (candidates.any!(x => x == '*'))
            {
                debug {
                }

                for (int ii = max(i-1, 0); ii < min(i+2, n); ii++)
                    for (int jj = max(j-1, 0); jj < min(k+1, m); jj++)
                    {
                        debug {
                            writeln(input[ii][jj]);
                        }
                        if (input[ii][jj] == '*')
                            gears[tuple(ii, jj)] ~= input[i][j..k].to!int;
                    }
            }

            j = k;
        }
    }

    gears.values
         .filter!(x => x.length == 2)
         .map!(x => x[0] * x[1])
         .sum
         .writeln;
}
