import std.stdio;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

int main(string[] args)
{
    int f = 0;
    int p = 0;

    while (!stdin.eof)
    {
        auto c = read!char;
        if (c == '(')
            f++;
        else if (c == ')')
            f--;
        p++;
        if (f == -1)
        {
            writeln(p);
            return 0;
        }
    }

    // writeln(f);

    return 0;
}
