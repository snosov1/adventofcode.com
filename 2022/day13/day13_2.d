import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;

bool compare(string left, string right)
{
    auto delist = (string s){
                int depth = 0;
                int prev = 1;
                string[] ret;
                foreach (i; 1..s.length-1)
                {
                    if (s[i] == '[')
                        depth++;
                    else if (s[i] == ']')
                        depth--;
                    else if (s[i] == ',' && depth == 0)
                    {
                        ret ~= s[prev..i];
                        prev = i+1;
                    }
                }
                if (prev < s.length-1)
                    ret ~= s[prev..s.length-1];
                return ret;
    };

    if (left[0] != '[' && right[0] != '[')
    {
        return left.to!int < right.to!int;
    }
    else if (left[0] != '[' && right[0] == '[')
    {
        return cmp!compare(
            [left],
            delist(right)
            ) < 0;
    }
    else if (left[0] == '[' && right[0] != '[')
    {
        return cmp!compare(
            delist(left),
            [right]
            ) < 0;
    }

    return cmp!compare(
        delist(left),
        delist(right)
        ) < 0;
}

void main(string[] args)
{
    auto pairs = stdin.byLineCopy
                      .filter!(x => x != "")
                      .array
                      .sort!compare;

    auto s = pairs.find("[[2]]");
    auto e = pairs.find("[[6]]");

    writeln((pairs.length - s.length + 1) * (pairs.length - e.length + 1));
}
