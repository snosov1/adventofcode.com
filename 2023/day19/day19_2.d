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

    Tuple!(int, int)[char][string][] limits;
    limits ~= ["A" : [
            'x' : tuple(1, 4000),
            'm' : tuple(1, 4000),
            'a' : tuple(1, 4000),
            's' : tuple(1, 4000),
            ]];

    Tuple!(int, int)[char][string][] new_limits;
    Tuple!(int, int)[char][string][] accepted_limits;
    foreach (T; 0..100)
    {
        foreach (limit; limits)
        {
            // writeln("limit = ", limit);
            // writeln("new_limits = ", new_limits);

            foreach (name, rules; workflows)
            {
                foreach (target, ranges; limit)
                {
                    auto rs = ranges.dup;

                    foreach (rule; rules)
                    {
                        if (rule.target == target)
                        {
                            auto rsd = rs.dup;
                            if (rule.cmp == '<')
                                rs[rule.category][1] = min(rs[rule.category][1], rule.value - 1);
                            else if (rule.cmp == '>')
                                rs[rule.category][0] = max(rs[rule.category][0], rule.value + 1);
                            else
                            {
                                new_limits ~= [name : rs];
                                break;
                            }

                            new_limits ~= [name : rs];

                            if (rule.cmp == '<')
                                rsd[rule.category][0] = max(rsd[rule.category][0], rule.value);
                            else if (rule.cmp == '>')
                                rsd[rule.category][1] = min(rsd[rule.category][1], rule.value);

                            rs = rsd;
                        }
                        else
                        {
                            if (rule.cmp == '<')
                                rs[rule.category][0] = max(rs[rule.category][0], rule.value);
                            else if (rule.cmp == '>')
                                rs[rule.category][1] = min(rs[rule.category][1], rule.value);
                            else
                                break;
                        }
                    }
                }
            }
        }

        if (new_limits.length == 0)
            break;

        int ndel = 0;
        foreach (i; 0..new_limits.length)
        {
            if (new_limits[new_limits.length - 1 - i].keys.front == "in")
            {
                accepted_limits ~= new_limits[$ - 1 - i];
                new_limits.remove(new_limits.length - 1 - i);
                ndel++;
                continue;
            }

            // if (new_limits[$ - 1 - i].values.front.any!(x => x.[0] > x[1]))
            // {
            //     new_limits = new_limits.remove(new_limits.length - 1 - i);
            //     continue;
            // }
        }
        new_limits.length -= ndel;

        // writeln("T = ", T);
        // new_limits.writeln;

        limits = new_limits.dup;
        new_limits.length = 0;
    }

    accepted_limits.map!(x => x.values.front.values.map!(y => y[1] - y[0] + 1L).fold!((a,b) => a * b)(1L)).sum.writeln;
}
