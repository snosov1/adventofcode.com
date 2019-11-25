import std.stdio;
import std.digest.md;
import std.conv;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

int main(string[] args)
{
    for (size_t i = 1; i < size_t.max; i++)
    {
        ubyte[16] hash = md5Of("iwrupvqb" ~ i.to!string);
        if (toHexString(hash)[0..6] == "000000")
        {
            writeln(i);
            return 0;
        }
    }

    return 0;
}
