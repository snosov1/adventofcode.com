import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.typecons;
import std.math;

alias deps_t = bool[char];

int main(string[] args)
{
    deps_t[char] dict;
    stdin.byLine
         .each!(
             (a){
                 auto s = a.split;
                 dict[s[7][0]][s[1][0]] = true;

                 if (s[1][0] !in dict)
                     dict[s[1][0]] = deps_t.init;
             }
         );

    auto letters = sequence!((a, n) => cast(char)(a[0] + n))('A').take('Z' - 'A' + 1);

    enum nworkers = 5;
    enum increase = 60;
    int[char] in_flight;
    int count = 0;

    while (dict.length > 0)
    {
        count++;

        for (int i = 0; i < letters.length; i++)
        {
            if (in_flight.length >= nworkers)
                break;

            auto l = letters[i];
            if (l in dict && l !in in_flight && dict[l].length == 0)
            {
                in_flight[l] = cast(int)(l - 'A') + increase + 1;
            }
        }

        foreach (k, v; in_flight)
        {
            if (v == 1)
            {
                in_flight.remove(k);
                dict.byKey
                    .each!((char a){
                        dict[a].remove(k);
                    });
                dict.remove(k);
            }
            else
                --in_flight[k];
        }

        debug
        {
            writeln(count-1, ": ", in_flight);
        }
    }

    count.writeln;

    return 0;
}
