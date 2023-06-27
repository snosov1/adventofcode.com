import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

struct Monkey
{
    int m;
    int[] items;
    string[] op;
    int div;
    int tm, fm;

    int inspect = 0;
}

int perform_op(int old, string[] op)
{
    int l = op[0] == "old" ? old : op[0].to!int;
    int r = op[2] == "old" ? old : op[2].to!int;

    if (op[1] == "+")
        return l + r;
    else if (op[1] == "*")
        return l * r;

    assert(0);
}

void main(string[] args)
{
    Monkey[] monkeys;
    while(!stdin.eof)
    {
        Monkey monkey;

        stdin.readf!"Monkey %d:\n"(monkey.m);

        string s;
        stdin.readf("  Starting items: %s\n", s);
        auto spec = singleSpec("%(%s, %)");
        monkey.items = s.unformatValue!(int[])(spec);

        string sop;
        stdin.readf("  Operation: new = %s\n", sop);
        monkey.op = sop.split;

        stdin.readf("  Test: divisible by %d\n", monkey.div);

        stdin.readf("    If true: throw to monkey %d\n", monkey.tm);
        stdin.readf("    If false: throw to monkey %d\n", monkey.fm);

        stdin.readln;

        monkeys ~= monkey;
    }

    debug writeln("  Monkeys: ");
    debug monkeys.each!(m => m.writeln);
    debug writeln;

    foreach (round; 0..20)
    {
        foreach (ref monkey; monkeys)
        {
            debug writeln("  Monkey inspector: ", monkey);

            foreach (item; monkey.items)
            {
                monkey.inspect++;
                int w = perform_op(item, monkey.op);
                w /= 3;
                if (w % monkey.div == 0)
                    monkeys[monkey.tm].items ~= w;
                else
                    monkeys[monkey.fm].items ~= w;
                monkey.items = monkey.items[1..$];

                debug monkeys.each!(m => m.writeln);
                debug writeln;
            }
        }
    }

    auto inspects = monkeys.map!(x => x.inspect).array.sort;
    writeln(inspects[$-1] * inspects[$-2]);
}
