import std.stdio;
import std.algorithm;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

int main(string[] args)
{
    int l, w, h;
    int s = 0;
    while (!stdin.eof)
    {
        readf(" %dx%dx%d ", &l, &w, &h);
        int a[] = [l, w, h];
        a.sort;
        // auto lw = l * w;
        // auto wh = w * h;
        // auto hl = h * l;

        // writeln(lw, " ", wh, " ", hl);

        // s += min(lw, wh, hl) + 2 * (lw + wh + hl);

        s += 2 * (a[0] + a[1]) + l * w * h;
    }

    writeln(s);

    return 0;
}
