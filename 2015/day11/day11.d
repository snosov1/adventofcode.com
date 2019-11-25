// --- Day 11: Corporate Policy ---

// Santa's previous password expired, and he needs help choosing a new one.

// To help him remember his new password after the old one expires, Santa has
// devised a method of coming up with a password based on the previous
// one. Corporate policy dictates that passwords must be exactly eight lowercase
// letters (for security reasons), so he finds his new password by incrementing
// his old password string repeatedly until it is valid.

// Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so
// on. Increase the rightmost letter one step; if it was z, it wraps around to
// a, and repeat with the next letter to the left until one doesn't wrap around.

// Unfortunately for Santa, a new Security-Elf recently started, and he has
// imposed some additional password requirements:

// Passwords must include one increasing straight of at least three letters,
// like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd
// doesn't count.

// Passwords may not contain the letters i, o, or l, as these letters can be
// mistaken for other characters and are therefore confusing.

// Passwords must contain at least two different, non-overlapping pairs of
// letters, like aa, bb, or zz.

// For example:

// hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement requirement (because it contains i and l).

// abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.

// abbcegjk fails the third requirement, because it only has one double letter (bb).

// The next password after abcdefgh is abcdffaa.

// The next password after ghijklmn is ghjaabcc, because you eventually skip all
// the passwords that start with ghi..., since i is not allowed.

// Given Santa's current password (your puzzle input), what should his next password be?

// Your puzzle input is hepxcrrq.

import std.stdio;
import std.range;
import std.array;
import std.utf;
import std.string;
import std.conv;
import std.algorithm;

char[] inc(char[] s, int times = 1)
{
    if (times == 0)
        return s;

    for (size_t i = s.length - 1; i >= 0; i--)
    {
        if (s[i] == 'z')
        {
            s[i] = 'a';
        }
        else
        {
            s[i]++;
            break;
        }
    }

    return inc(s, --times);
}

bool rule1(char[] s)
{
    for (size_t i = 0; i < s.length - 2; i++)
    {
        if ((s[i+1] - s[i] == 1) && (s[i+2] - s[i+1] == 1))
            return true;
    }
    return false;
}

bool rule2(char[] s)
{
    return s.indexOfAny("iol") < 0;
}

bool rule3(char[] s)
{
    auto r = s.findAdjacent;
    if (r.empty)
        return false;
    return !r[2..$].findAdjacent.empty;
}

int main(string[] args)
{
    //char[] pass = "hepxcrrq".retro.byChar.array;
    char[] pass = "hepxcrrq".to!(char[]);
    //char[] pass = "ghijklmn".to!(char[]);

    for (;;)
    {
        pass.inc;
        if (pass.rule1 && pass.rule2 && pass.rule3)
            break;
    }

    for (;;)
    {
        pass.inc;
        if (pass.rule1 && pass.rule2 && pass.rule3)
            break;
    }

    writeln(pass);

    return 0;
}
