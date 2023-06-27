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

struct Monkey
{
    string name;
    bool knows;
    long number;
    string left, right, op;
}

Monkey[string] monkeys;

long get(string name)
{
    auto m = monkeys[name];
    if (m.knows)
        return m.number;

    long left = get(m.left);
    long right = get(m.right);

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

    m.knows = true;
    return m.number;
}

int main(string[] args)
{
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

    get("root").writeln;

    return 0;
}
