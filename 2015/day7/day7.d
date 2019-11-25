import std.stdio;
import std.format;
import std.ascii;
import std.algorithm;
import std.conv;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

alias gate = ushort function(ushort l, ushort r);

struct Op
{
    string lhs;
    string rhs;
    string res;
    gate op;
}

gate ops[string];
Op[] circuit;
static this()
{
    ops = [
        "NOT " : (ushort l, ushort r) { return ~r; },
        " AND " : (ushort l, ushort r) { return cast(ushort)(l & r); },
        " OR " : (ushort l, ushort r) { return cast(ushort)(l | r); },
        " LSHIFT " : (ushort l, ushort r) { return cast(ushort)(l << r); },
        " RSHIFT " : (ushort l, ushort r) { return cast(ushort)(l >> r); },
        "IDENTITY" : (ushort l, ushort r) { return r; }
        ];
}

Op parse(string line)
{
    auto r = line.findSplit(" -> ");
    Op op;
    op.res = r[2];

    // for the second gold star
    if (op.res == "b")
    {
        op.lhs = "";
        op.rhs = "956";
        op.op = ops["IDENTITY"];
        return op;
    }

    bool found = false;
    foreach (s, g; ops)
    {
        auto q = r[0].findSplit(s);
        if (q[1].length != 0)
        {
            op.lhs = q[0];
            op.rhs = q[2];
            op.op = g;
            found = true;
        }
    }

    if (!found)
    {
        op.rhs = r[0];
        op.op = ops["IDENTITY"];
    }

    return op;
}

ushort cache[string];

ushort evalCircuit(string s)
{
    writeln("evaluating ", s, ": ");

    if (s.length == 0)
        return 0;

    if (s[0].isDigit)
        return s.to!ushort;

    ushort *p = s in cache;
    if (p !is null)
        return *p;

    foreach (c; circuit)
    {
        if (c.res == s)
        {
            writeln("operate on ", c.lhs, " ", c.rhs);
            ushort res = c.op(evalCircuit(c.lhs), evalCircuit(c.rhs));
            cache[s] = res;
            return res;
        }
    }

    writeln("Broken circuit");
    assert(0);
}

int main(string[] args)
{
    foreach (line; stdin.byLine)
    {
        circuit ~= parse(line.to!string);
    }

    writeln(evalCircuit("a"));

    return 0;
}
