import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{
    auto input = stdin.byLineCopy.array.splitter("");
    auto stacks = input.front.array;
    input.popFront;
    auto instructions = input.front;
    int N = (stacks.front.length + 1) / 4;
    stacks.popBack;

    auto state = new char[][N];
    foreach (s; stacks.retro)
    {
        foreach (i, b; s[1..$].stride(4).enumerate)
        {
            if (b != ' ')
                state[i] ~= b;
        }
    }

    foreach (i; instructions)
    {
        int n, f, t;
        i.formattedRead("move %d from %d to %d", n, f, t);
        f--;
        t--;

        state[t] ~= state[f][$ - n..$];
        state[f].length -= n;
    }

    state.map!(x => x[$-1]).writeln;
}
