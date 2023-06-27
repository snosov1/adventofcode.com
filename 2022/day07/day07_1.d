import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{
    int[string] dirs;
    string[] current_dir = ["/"];

    foreach (line; stdin.byLineCopy)
    {
        // handle cd
        if (line[0..4] == "$ cd")
        {
            auto target = line[5..$];
            if (target == "/")
                current_dir = ["/"];
            else if (target == "..")
                current_dir.popBack;
            else
                current_dir ~= target;
        }
        else if (line[0..4] == "$ ls" || line[0..3] == "dir")
        {
            continue;
        }
        else
        {
            auto size = line[0..line.countUntil(' ')].to!int;
            auto cd = current_dir.dup;

            while (cd.length > 0)
            {
                dirs.update(cd.join("/"),
                () => size,
                (ref int v) => v += size
                    );
                cd.popBack;
            }
        }
    }
    writeln(dirs.values.filter!(x => x <= 100_000).sum);
}
