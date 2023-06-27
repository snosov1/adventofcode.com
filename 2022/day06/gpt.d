import std.stdio;
import std.conv;
import std.algorithm;
import std.array;
import std.container;


int findMarker(string inputStr)
{
    ubyte[] lastFour;
    lastFour.length = 4;

    foreach (i, c; inputStr)
    {
        // shift the array by one element
        lastFour[0 .. 3] = lastFour[1 .. $];
        lastFour[3] = c.to!ubyte;

        // sort and eliminate adjacent duplicate characters
        auto sorted = sort(lastFour);
        auto uniqueChars = uniq(sorted);

        // check if the last four characters are all unique
        if (uniqueChars.array.length == 4)
            return i + 1;
    }

    return -1;
}

void main()
{
    string inputStr = "mjqjpqmgbljsphdztnvjfqwrcgsmlb";
    writeln(findMarker(inputStr));  // should print 7

    inputStr = "bvwbjplbgvbhsrlpgdmjqwftvncz";
    writeln(findMarker(inputStr));  // should print 5

    inputStr = "nppdvjthqldpwncqszvftbrmjlhg";
    writeln(findMarker(inputStr));  // should print 6

    inputStr = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg";
    writeln(findMarker(inputStr));  // should print 10

    inputStr = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw";
    writeln(findMarker(inputStr));  // should print 11
}
