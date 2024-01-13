import std;

void main(string[] args)
{
    auto input = stdin.byLineCopy.array.splitter("");

    struct rule_t
    {
        char category;
        char cmp;
        int value;
        string target;
    }

    rule_t[][string] workflows;

    foreach (wf; input.front)
    {
        auto rs = wf.find("{");
        rs.popFront;
        rs.popBack;

        rule_t[] rules;
        foreach (r; rs.split(","))
        {
            rule_t rule;
            if (r.canFind(":"))
            {
                r.formattedRead("%c%c%d:%s", &rule.category, &rule.cmp, &rule.value, &rule.target);
            }
            else
            {
                rule.target = r;
            }

            rules ~= rule;
        }

        workflows[wf[0..$-rs.length-2]] = rules;
    }

    int[char][] ratings;
    input.popFront;
    foreach (r; input.front)
    {
        r.popFront;
        r.popBack;
        int[char] rating;
        foreach (c; r.split(","))
            rating[c[0]] = c[2..$].to!int;
        ratings ~= rating;
    }

    int[char][] accepted;
    foreach (r; ratings)
    {
        string state = "in";
        debug {
            r.writeln;
        }
        while(state != "A" && state != "R")
        {
            debug {
                state.writeln;
            }
            foreach (rule; workflows[state])
            {
                if (rule.category == char.init)
                {
                    state = rule.target;
                    break;
                }

                bool match = rule.cmp == '<' ?
                             r[rule.category] < rule.value :
                             r[rule.category] > rule.value;

                if (match)
                {
                    state = rule.target;
                    break;
                }
            }
        }

        if (state == "A")
            accepted ~= r;
    }

    //accepted.writeln;
    accepted.map!(x => x.values.sum).sum.writeln;
}
