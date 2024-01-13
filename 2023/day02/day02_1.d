import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;

void main(string[] args)
{
    auto limits = [
        "red" : 12,
        "green": 13,
        "blue": 14
        ];

    int s = 0;
    foreach (line; stdin.byLine)
    {
        bool possible = true;
        foreach (round; line.find(": ")[2..$].split("; "))
        {
            foreach (ball; round.split(", "))
            {
                auto n = ball.split(" ");
                if (n[0].to!int > limits[n[1]])
                {
                    possible = false;
                    break;
                }
            }

            if (!possible)
                break;
        }

        if (possible)
        {
            int id;
            line.formattedRead("Game %d: ", &id);
            s += id;
        }
    }

    writeln(s);

}
