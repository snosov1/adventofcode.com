// --- Day 19: Medicine for Rudolph ---

// Rudolph the Red-Nosed Reindeer is sick! His nose isn't shining very brightly,
// and he needs medicine.

// Red-Nosed Reindeer biology isn't similar to regular reindeer biology; Rudolph
// is going to need custom-made medicine. Unfortunately, Red-Nosed Reindeer
// chemistry isn't similar to regular reindeer chemistry, either.

// The North Pole is equipped with a Red-Nosed Reindeer nuclear fusion/fission
// plant, capable of constructing any Red-Nosed Reindeer molecule you need. It
// works by starting with some input molecule and then doing a series of
// replacements, one per step, until it has the right molecule.

// However, the machine has to be calibrated before it can be used. Calibration
// involves determining the number of molecules that can be generated in one
// step from a given starting point.

// For example, imagine a simpler machine that supports only the following replacements:

// H => HO
// H => OH
// O => HH

// Given the replacements above and starting with HOH, the following molecules
// could be generated:

// HOOH (via H => HO on the first H).
// HOHO (via H => HO on the second H).
// OHOH (via H => OH on the first H).
// HOOH (via H => OH on the second H).
// HHHH (via O => HH).

// So, in the example above, there are 4 distinct molecules (not five, because
// HOOH appears twice) after one replacement from HOH. Santa's favorite
// molecule, HOHOHO, can become 7 distinct molecules (over nine replacements:
// six from H, and three from O).

// The machine replaces without regard for the surrounding characters. For
// example, given the string H2O, the transition H => OO would result in OO2O.

// Your puzzle input describes all of the possible replacements and, at the
// bottom, the medicine molecule for which you need to calibrate the
// machine. How many distinct molecules can be created after all the different
// ways you can do one replacement on the medicine molecule?

// --- Part Two ---

// Now that the machine is calibrated, you're ready to begin molecule
// fabrication.

// Molecule fabrication always begins with just a single electron, e, and
// applying replacements one at a time, just like the ones during calibration.

// For example, suppose you have the following replacements:

// e => H
// e => O
// H => HO
// H => OH
// O => HH
// If you'd like to make HOH, you start with e, and then make the following replacements:

// e => O to get O
// O => HH to get HH
// H => OH (on the second H) to get HOH

// So, you could make HOH after 3 steps. Santa's favorite molecule, HOHOHO, can
// be made in 6 steps.

// How long will it take to make the medicine? Given the available replacements
// and the medicine molecule in your puzzle input, what is the fewest number of
// steps to go from e to the medicine molecule?

import std.stdio;
import std.algorithm;
import std.conv;

alias reps_t = string[];

int expand(string current, string target, reps_t[string] replacements, int count)
{
    writeln(current);

    if (current == target)
        return count;

    if (current.length >= target.length)
        return -1;

    int[] rets;

    foreach (r0, r2s; replacements)
    {
        foreach (r2; r2s)
        {
            string prefix = "";
            string suffix = current.idup;

            while (suffix.length > 0)
            {
                auto r = suffix.findSplit(r0);

                if (r[1] != r0)
                    break;

                prefix ~= r[0];
                suffix = r[2];

                rets ~= expand(prefix ~ r2 ~ suffix, target, replacements, count + 1);

                prefix ~= r[1];
            }
        }
    }

    auto q = rets.filter!(a => a > 0).minPos;
    if (q.empty)
        return -1;
    else
        return q.front;
}

int[string] cache;

int collapse(string current, string target, reps_t[string] replacements, int count)
{
    int *p = current in cache;
    if (p !is null)
        return *p;

    writeln(current);

    if (current == target)
        return count;

    int[] rets;

    foreach (r0, r2s; replacements)
    {
        foreach (r2; r2s)
        {
            string prefix = "";
            string suffix = current.idup;

            while (suffix.length > 0)
            {
                auto r = suffix.findSplit(r2);

                if (r[1] != r2)
                    break;

                prefix ~= r[0];
                suffix = r[2];

                auto new_current = prefix ~ r0 ~ suffix;

                //assert(new_current.length < current.length);
                if (new_current.length < current.length)
                    rets ~= collapse(new_current, target, replacements, count + 1);

                prefix ~= r[1];
            }
        }
    }

    auto q = rets.filter!(a => a > 0).minPos;
    auto ret = -1;
    if (!q.empty)
        ret = q.front;

    cache[current] = ret;

    return ret;
}

alias division_t = int[];

bool inc(division_t d, int n)
{
    auto i = d.length - 1;
    d[i]++;

    while (d[i] == n && i > 0)
    {
        i--;
        d[i]++;
    }

    if (i == 0 && d[i] == n)
    {
        return false;
    }

    for (auto j = i + 1; j < d.length; j++)
    {
        d[j] = d[i];
    }

    return true;
}

string[] terms(string term)
{
    int last = 0;
    string[] ret;
    for (int i = 1; i < term.length; i++)
    {
        if (term[i] >= 'a' && term[i] <= 'z')
            continue;

        ret ~= term[last..i];
        last = i;
    }

    if (last != term.length)
        ret ~= term[last..term.length];

    return ret;
}

reps_t[string] from_which_terms;

int divide(string term, string target, reps_t[string] replacements, int count)
{
    int[] rets;

    foreach (r; replacements[term])
    {
        auto ts = terms(r);
        division_t d;
        d.length = ts.length;

        do
        {
            auto dd = d ~ [cast(int)(target.length) - 1];

            auto res = 0;
            for (int i = 0; i < d.length - 1; i++)
            {
                auto c = divide(ts[i], target[dd[i]..dd[i+1]+1], replacements, count + 1);

                if (c < 0)
                {
                    res = -1;
                    break;
                }
                res += c;
            }

            if (res > 0)
                rets ~= res;
        }
        while (inc(d, cast(int)(target.length)));
    }

    auto q = rets.filter!(a => a > 0).minPos;
    auto ret = -1;
    if (!q.empty)
        ret = q.front;



    return ret;
}

int main(string[] args)
{
    reps_t[string] replacements;

    foreach (line; stdin.byLine)
    {
        if (line.length == 0)
            break;

        auto r = line.findSplit(" => ");
        replacements[r[0].to!string] ~= r[2].to!string;
    }

    string mol = readln[0..$-1];

    int[string] options;

    foreach (r0, r2s; replacements)
    {
        foreach (r2; r2s)
        {
            string prefix = "";
            string suffix = mol.idup;

            while (suffix.length > 0)
            {
                //writeln(r0, ", ", r2, ", ", prefix, ", ", suffix);

                auto r = suffix.findSplit(r0);

                if (r[1] != r0)
                    break;

                prefix ~= r[0];
                suffix = r[2];
                options[prefix ~ r2 ~ suffix] = 1;
                prefix ~= r[1];
            }
        }
    }

    //writeln(options.length);

    //writeln(expand("e", mol, replacements, 0));
    //writeln(collapse(mol, "e", replacements, 0));
    writeln(divide("e", mol, replacements, 0));

    return 0;
}
