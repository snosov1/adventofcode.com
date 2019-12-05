import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.string;

void main(string[] args)
{
    int[] a, orig;
    stdin.readln.strip.formattedRead!"%(%s,%)"(a);
    orig = a.dup;

    for (int noun = 0; noun < 100; noun++)
    {
        for (int verb = 0; verb < 100; verb++)
        {
            a = orig.dup;

            a[1] = noun;
            a[2] = verb;

            int i = 0;
            while (true)
            {
                if (a[i] == 1)
                    a[a[i + 3]] = a[a[i + 1]] + a[a[i + 2]];
                else if (a[i] == 2)
                    a[a[i + 3]] = a[a[i + 1]] * a[a[i + 2]];
                else
                    break;
                i += 4;
            }

            if (a[0] == 19690720)
            {
                writeln(100 * noun + verb);
                break;
            }
        }
    }

}
