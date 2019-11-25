import std.stdio;
import std.algorithm;
import std.typecons;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

int main(string[] args)
{
    int houses[Tuple!(int, int)];
    int s = 0;
    int x = 0;
    int y = 0;
    int xr = 0;
    int yr = 0;

    houses[tuple(0, 0)] = 1;

    while (!stdin.eof)
    {
        char c = read!char;

        if (c == '^')
        {
            if (s % 2)
                y++;
            else
                yr++;
        }
        else if (c == 'v')
        {
            if (s % 2)
                y--;
            else
                yr--;
        }
        else if (c == '>')
        {
            if (s % 2)
                x++;
            else
                xr++;
        }
        else if (c == '<')
        {
            if (s % 2)
                x--;
            else
                xr--;
        }

        if (s % 2)
            houses[tuple(x, y)] = 1;
        else
            houses[tuple(xr, yr)] = 1;

        s = (s + 1) % 2;
    }

    writeln(houses.length);

    return 0;
}
