import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;

int compare(string left, string right)
{
    auto delist = (string s){
                int depth = 0;
                int prev = 1;
                foreach (i; 1..s.length-1)
                {
                    if (s[i] == '[')
                        depth++;
                    else if (s[i] == ']')
                        depth--;
                    else if (s[i] == ',' && depth == 0)
                    {
                        yield(s[prev..i]);
                        prev = i+1;
                    }
                }
                if (prev < s.length-1)
                    yield(s[prev..s.length-1]);
    };

    if (left[0] != '[' && right[0] != '[')
    {
        return left.to!int < right.to!int;
    }
    else if (left[0] != '[' && right[0] == '[')
    {
        return cmp!compare(
            [left],
            new Generator!string({delist(right);})
            ) < 0;
    }
    else if (left[0] == '[' && right[0] != '[')
    {
        return cmp!compare(
            new Generator!string({delist(left);}),
            [right]
            ) < 0;
    }

    return cmp!compare(
        new Generator!string({delist(left);}),
        new Generator!string({delist(right);})
        ) < 0;
}

void main(string[] args)
{
    auto pairs = stdin.byLineCopy.array.splitter("");

    // writeln(compare(pairs.front[0], pairs.front[1]));

    pairs.map!(x => compare(x[0], x[1])).enumerate(1)
         .map!(x => x[0] * x[1])
         .sum
         .writeln;
}
