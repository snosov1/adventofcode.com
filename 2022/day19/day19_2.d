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

struct Blueprint
{
    int id;
    int ore_ore;
    int clay_ore;
    int obsidian_ore;
    int obsidian_clay;
    int geode_ore;
    int geode_obsidian;
}

struct State
{
    int ore;
    int clay;
    int obsidian;
    int geode;

    int ore_bots;
    int clay_bots;
    int obsidian_bots;
    int geode_bots;
}

bool useless(string bot, Blueprint bp, State s, int m)
{
    if (bot == "ore")
        return s.ore_bots >= max(bp.clay_ore, bp.obsidian_ore, bp.geode_ore) || s.ore >= max(bp.clay_ore, bp.obsidian_ore, bp.geode_ore) * m;
    else if (bot == "clay")
        return s.clay_bots >= bp.obsidian_clay || s.clay >= bp.obsidian_clay * m;
    else if (bot == "obsidian")
        return s.obsidian_bots >= bp.geode_obsidian || s.obsidian >= bp.geode_obsidian * m;

    return false;
}

bool useful(string bot, Blueprint bp, State s, int m)
{
    auto res = useless(bot, bp, s, m);

    // if (res)
    //     writeln(res);

    return !res;
}

int go(Blueprint bp, State s, int m)
{
    // if (s.geode > 10)
    //     writeln(bp, s, m);
    State ns = s;

    ns.ore      += ns.ore_bots;
    ns.clay     += ns.clay_bots;
    ns.obsidian += ns.obsidian_bots;
    ns.geode    += ns.geode_bots;

    if (m == 1)
        return ns.geode;

    if (s.obsidian >= bp.geode_obsidian && s.ore >= bp.geode_ore)
    {
        ns.geode_bots++;
        ns.obsidian -= bp.geode_obsidian;
        ns.ore -= bp.geode_ore;
        return go(bp, ns, m - 1);
    }

    int[] search;
    if (s.clay >= bp.obsidian_clay && s.ore >= bp.obsidian_ore && useful("obsidian", bp, s, m))
    {
        ns.obsidian_bots++;
        ns.clay -= bp.obsidian_clay;
        ns.ore -= bp.obsidian_ore;

        return go(bp, ns, m - 1);
        //search ~= go(bp, ns, m - 1);

        // ns.obsidian_bots--;
        // ns.clay += bp.obsidian_clay;
        // ns.ore += bp.obsidian_ore;
    }

    if (s.ore >= bp.clay_ore && useful("clay", bp, s, m))
    {
        ns.clay_bots++;
        ns.ore -= bp.clay_ore;

        search ~= go(bp, ns, m - 1);

        ns.clay_bots--;
        ns.ore += bp.clay_ore;
    }

    if (s.ore >= bp.ore_ore && useful("ore", bp, s, m))
    {
        ns.ore_bots++;
        ns.ore -= bp.ore_ore;

        search ~= go(bp, ns, m - 1);

        ns.ore_bots--;
        ns.ore += bp.ore_ore;
    }

    if (s.ore < 6)
        search ~= go(bp, ns, m - 1);

    return search.maxElement;

}

int main(string[] args)
{
    auto blueprints = stdin.byLine.map!((x){
        Blueprint a;
        x.formattedRead("Blueprint %d: Each ore robot costs %d ore. Each clay robot costs %d ore. Each obsidian robot costs %d ore and %d clay. Each geode robot costs %d ore and %d obsidian.",
            a.id, a.ore_ore, a.clay_ore, a.obsidian_ore, a.obsidian_clay, a.geode_ore, a.geode_obsidian);
        return a;
    }).array;

    int ans = 1;
    foreach (bp; blueprints[0..min(3, $)])
    {
        State s;
        s.ore_bots = 1;
        int g = go(bp, s, 32);
        ans *= g;

        writeln(g, " ", bp);
    }

    ans.writeln; // 7644 - correct!

    return 0;
}
