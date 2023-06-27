import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;
import std.ascii;
import std.random;
import std.parallelism;

struct Monkey
{
    string name;
    bool knows;
    long number;
    string left, right, op;
}

long get(Monkey[string] monkeys, string name, bool precalc = false)
{
    if (precalc && name == "humn")
        return long.min;

    auto m = monkeys[name];
    if (m.knows)
        return m.number;

    long left = get(monkeys, m.left, precalc);
    // writeln("left = ", left);
    if (precalc && left == long.min)
        return long.min;

    long right = get(monkeys, m.right, precalc);
    // writeln("right = ", right);
    if (precalc && right == long.min)
        return long.min;

    if (m.op.front == '+')
        m.number = left + right;
    else if (m.op.front == '-')
        m.number = left - right;
    else if (m.op.front == '*')
        m.number = left * right;
    else if (m.op.front == '/')
        m.number = left / right;
    else
        assert(0);

    // writeln("m.number = ", m.number);

    m.knows = true;
    monkeys[name] = m;
    return m.number;
}

int main(string[] args)
{
    Monkey[string] monkeys;

    foreach (line; stdin.byLineCopy)
    {
        Monkey m;
        m.name = line[0..4];
        if (line[6].isDigit)
        {
            m.number = line[6..$].to!long;
            m.knows = true;
        }
        else
        {
            m.left = line[6..10];
            m.op = line[11..12];
            m.right = line[13..$];
        }

        monkeys[m.name] = m;
    }


    auto root = monkeys["root"];

    auto begin = 3_916_491_050_000; // just observed that "right" is constant, and "left" is close to linear. no idea why
    foreach (guess; begin..begin+100000)
    {
        auto md = monkeys.dup;
        md["humn"].number = guess;

        auto left = get(md, root.left);
        auto right = get(md, root.right);

        if (left == right)
        {
            guess.writeln;
            return 0;
        }
    }


    return 0;
}
