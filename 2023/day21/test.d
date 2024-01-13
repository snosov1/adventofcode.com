import std;

int mod(int x, int m)
{
    return ((x % m) + m) % m;
}

int div(int x, int m)
{
    int r = mod(x, m);

    if (x >= 0)
        return (x - r) / m;

    return (- x - 1 + m) / m;
}

int main() {
    int x = -4, m = 3;
    writeln(mod(x, m), " ", div(x, m));

    return 0;
}
