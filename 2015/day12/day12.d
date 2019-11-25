import std.stdio;
import std.algorithm;
import std.regex;
import std.conv;
import std.typecons;
import std.range;

// 1 star
// int main(string[] args)
// {
//     writeln(
//         readln[0..$-1]
//             .split(regex("[\\[\\]\"a-z:,{}]"))
//             .filter!(a => a.length != 0)
//             .map!(a => a.to!int)
//             .reduce!((a, b) => a + b)
//     );
//     return 0;
// }

// 2 stars
int main(string[] args)
{
    auto input = readln[0..$-1];
    int[] braces;

    for (int i = 0; i < input.length; i++)
    {
        if (input[i] == '{')
        {
            braces ~= i;
        }
        else if (input[i] == '}')
        {
            if (input[braces[$-1]..i+1].canFind(":\"red\""))
            {
                input = input[0..braces[$-1]] ~ input[i+1..$];
                i -= (i+1 - braces[$-1]) + 1;
            }

            braces.length--;
        }
    }

    writeln(
        input
        .split(regex("[\\[\\]\"a-z:,{}]"))
        .filter!(a => a.length != 0)
        .map!(a => a.to!int)
        .reduce!((a, b) => a + b)
        );

    return 0;
}
