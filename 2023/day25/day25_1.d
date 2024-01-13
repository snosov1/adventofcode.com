import std;

int main(string[] args)
{
    string[][string] g;
    foreach (line; stdin.byLine)
    {
        auto s = line.findSplit(": ");

        foreach (node; s[2].split(" "))
        {
            auto n1 = s[0].idup;
            auto n2 = node.idup;

            // this year had too many bullshit problems. this is a perfect ending
            if (
                n1 == "qpp" && n2 == "vnm" ||
                n1 == "vnm" && n2 == "qpp" ||

                n1 == "rhk" && n2 == "bff" ||
                n1 == "bff" && n2 == "rhk" ||

                n1 == "kfr" && n2 == "vkp" ||
                n1 == "vkp" && n2 == "kfr"
                )
                continue;


            g[n1] ~= n2;
            g[n2] ~= n1;
        }
    }

    int[string] visited;
    string[] queue;
    queue ~= g.keys.front;
    visited[queue.front] = 1;

    while (!queue.empty)
    {
        auto c = queue.front;
        queue.popFront;

        foreach (v; g[c].filter!(x => x !in visited))
        {
            queue ~= v;
            visited[v] = 1;
        }
    }

    writeln(visited.length * (g.keys.length - visited.length));


    // writeln("graph {");
    // foreach (n1; g.keys)
    // {
    //     foreach (n2; g[n1])
    //     {
    //         writeln(n1, " -- ", n2, ";");
    //     }
    // }
    // writeln("}");

    //g.writeln;

    return 0;
}
