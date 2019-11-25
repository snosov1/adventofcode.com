import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.utf;
import std.string;

string collapse(string s)
{
    char[] input = s.dup;
    for (int i = 0; i < cast(int)input.length - 1; )
    {
        if (input[i].toUpper == input[i+1].toUpper && input[i] != input[i+1])
        {
            input = input[0..i] ~ input[i+2..$];
            i = max(0, i-1);
        }
        else
        {
            i++;
        }
    }

    return input.to!string;
}

ubyte toUpper(ubyte c)
{
    return isLower(c) ? cast(ubyte)(c - ('a' - 'A')) : c;
}

ubyte toLower(ubyte c)
{
    return isUpper(c) ? cast(ubyte)(c + 'a' - 'A') : c;
}

void main(string[] args)
{
    auto input = stdin.byLine.front.representation;
    auto orig = input.assumeUTF.to!string;

    input.map!toUpper.copy(input);
    sort(input);

    int[] lens;
    foreach (c; input.uniq.array.assumeUTF)
    {
        lens ~= orig.byChar.filter!(a => a != c && a != c.toLower)
                    .to!string
                    .collapse
                    .length
                    .to!int;
    }

    lens.minElement.writeln;
}
