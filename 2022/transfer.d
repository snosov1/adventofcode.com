import std.file;
import std.stdio;
import std.algorithm;
import std.path;
import std.array;
import std.range;
import std.conv;

int main(string[] args)
{
    if (args.length < 2)
    {
        writeln("Usage: " ~ args[0] ~ " <folder>");
        return 0;
    }

    enum header = "%% ";

    if (stdin.size == 0)
    {
        auto skip_extensions = ["exe", "obj"];
        foreach (DirEntry e; args[1].dirEntries(SpanMode.depth)
                                    .filter!(x => !x.isDir)
                                    .filter!(x => !skip_extensions.map!(ext => x.name.endsWith(ext)).any))
        {

            writeln(header ~ e.name);
            writeln(e.name.readText);
        }
    }
    else
    {

        foreach (f; stdin.byLineCopy.array.splitWhen!((x, y) => y.startsWith(header)))
        {
            auto filepath = f.front[header.length..$];
            f.popFront;
            mkdirRecurse(buildPath(args[1], filepath.dirName));
            f.joiner("\n").to!string.toFile(buildPath(args[1], filepath));
        }
    }

    return 0;
}
