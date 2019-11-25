import std.stdio;
import std.digest.md;
import std.conv;
import std.algorithm;

T read(T)()
{
    T t;
    readf(" %s", &t);
    return t;
}

bool rule1(char[] s)
{
    int n = 0;

    foreach (i; s)
    {
        if (
            i == 'a' ||
            i == 'e' ||
            i == 'i' ||
            i == 'o' ||
            i == 'u'
            )
        {
            n++;
        }
    }

    return n >= 3;
}

bool rule2(char[] s)
{
    int n = 0;

    for (size_t i = 1; i < s.length; i++)
    {
        if (s[i-1] == s[i])
            return true;
    }

    return false;
}

bool rule3(char[] s)
{
    int n = 0;

    for (size_t i = 1; i < s.length; i++)
    {
        if (
            s[i-1..i+1] == "ab" ||
            s[i-1..i+1] == "cd" ||
            s[i-1..i+1] == "pq" ||
            s[i-1..i+1] == "xy"
            )
            return false;
    }

    return true;
}

bool rule4(char[] s)
{
    int n = 0;

    for (size_t i = 0; i < s.length - 1; i++)
    {
        if (!s[i+2..$].find(s[i..i+2]).length == 0)
            return true;
    }

    return false;
}

bool rule5(char[] s)
{
    int n = 0;

    for (size_t i = 1; i < s.length - 1; i++)
    {
        if (s[i-1] == s[i+1])
            return true;
    }

    return false;
}

int main(string[] args)
{
    int c = 0;

    foreach (line; stdin.byLine)
    {
        //if (rule1(line) && rule2(line) && rule3(line))
        if (rule4(line) && rule5(line))
        {
            c++;
        }
    }
    writeln(c);
    return 0;
}
