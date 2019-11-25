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

    while (dict.length > 0)
    {
        for (int i = 0; i < letters.length; i++)
        {
            auto l = letters[i];
            if (l in dict && dict[l].length == 0)
            {
                write(l);
                dict.byKey
                    .each!((char a){
                        dict[a].remove(l);
                    });
                dict.remove(l);
                i = -1;
            }
        }
    }

    return 0;
}
