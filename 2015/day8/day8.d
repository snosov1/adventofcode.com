import std.stdio;

int main(string[] args)
{
    // 1 star
    // int rep = 0;
    // int code = 0;
    // foreach (line; stdin.byLine)
    // {
    //     int curr = 0;

    //     for (size_t i = 1; i < line.length - 1; i++)
    //     {
    //         writeln(curr, " ", line[i..$-1]);

    //         if (line[i] != '\\')
    //         {
    //             curr++;
    //             continue;
    //         }

    //         i++;

    //         if (line[i] == '\\')
    //         {
    //             curr++;
    //         }
    //         else if (line[i] == '"')
    //         {
    //             curr++;
    //         }
    //         else if (line[i] == 'x')
    //         {
    //             i += 2;
    //             curr++;
    //         }
    //     }

    //     rep += line.length;
    //     code += curr;
    // }
    // writeln(rep - code);

    // 2 star
    int rep = 0;
    int code = 0;
    foreach (line; stdin.byLine)
    {
        int curr = 2;

        for (size_t i = 0; i < line.length; i++)
        {
            writeln(curr, " ", line[i..$-1]);

            if (line[i] == '\\')
            {
                curr+=2;
            }
            else if (line[i] == '"')
            {
                curr+=2;
            }
            else
            {
                curr++;
            }
        }

        rep += line.length;
        code += curr;
    }

    writeln(code - rep);

    return 0;
}
