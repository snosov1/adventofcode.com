import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.string;

int getParam(int[] a, int p, int mode)
{
    if (mode)
        return a[p];
    else
        return a[a[p]];
}

void main(string[] args)
{
    int[] a;
    stdin.readln.strip.formattedRead!"%(%s,%)"(a);

    debug writeln(getParam(1, 0));

    int output = 0;
    int i = 0;
    while (true)
    {
        int modes = a[i] / 100;
        int opcode = a[i] % 100;
        int step = 0;

        debug writefln("opcode = %s, mode = %s", opcode, modes);
        debug a.writeln;

        if (opcode == 1)
        {
            debug writeln(modes % 10, " ", getParam(a, i+1, modes % 10), " ", getParam(a, i+2, modes % 10), " ", a[225]);

            auto p1 = getParam(a, i+1, modes % 10);
            modes /= 10;
            auto p2 = getParam(a, i+2, modes % 10);
            modes /= 10;

            a[a[i + 3]] = p1 + p2;
            step = 4;
        }
        else if (opcode == 2)
        {
            auto p1 = getParam(a, i+1, modes % 10);
            modes /= 10;
            auto p2 = getParam(a, i+2, modes % 10);
            modes /= 10;

            a[a[i + 3]] = p1 * p2;
            step = 4;
        }
        else if (opcode == 3)
        {
            a[a[i + 1]] = 5;
            step = 2;
        }
        else if (opcode == 4)
        {
            output = getParam(a, i+1, modes % 10);
            step = 2;
        }
        else if (opcode == 5 || opcode == 6)
        {
            auto c = getParam(a, i+1, modes % 10);
            modes /= 10;
            auto p = getParam(a, i+2, modes % 10);
            modes /= 10;

            if (opcode == 6)
                c = !c;

            if (c)
            {
                i = p;
                step = 0;
            }
            else
                step = 3;

        }
        else if (opcode == 7 || opcode == 8)
        {
            auto p1 = getParam(a, i+1, modes % 10);
            modes /= 10;
            auto p2 = getParam(a, i+2, modes % 10);
            modes /= 10;

            if (opcode == 7)
                a[a[i + 3]] = p1 < p2;
            else
                a[a[i + 3]] = p1 == p2;

            step = 4;
        }
        else
            break;
        i += step;
    }

    output.writeln;
}
