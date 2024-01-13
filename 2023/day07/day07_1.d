import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;

enum int[dchar] card_map = [
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'T': 10,
    'J': 11,
    'Q': 12,
    'K': 13,
    'A': 14
    ];

int handType(int[] hand)
{
    auto g = hand.dup.sort.group.array;

    if (g.length == 1)
        return 7; // five of a kind
    else if (g.length == 2 && g.map!(x => x[1]).maxElement == 4)
        return 6; // four of a kind
    else if (g.length == 2)
        return 5; // full house
    else if (g.length == 3 && g.map!(x => x[1]).maxElement == 3) // three of a kind
        return 4;
    else if (g.length == 3) // two pair
        return 3;
    else if (g.length == 4) // one pair
        return 2;
    else
        return 1;

    return -1;
}

bool lessHand(int[] l, int[] r)
{
    auto lht = l.handType;
    auto rht = r.handType;

    if (lht < rht)
        return true;

    if (lht > rht)
        return false;

    return cmp(l, r) < 0;
}

unittest {
    assert(handType([2, 2, 2, 2, 2]) == 7);

    assert(handType([2, 2, 3, 2, 2]) == 6);
    assert(handType([2, 2, 2, 1, 2]) == 6);

    assert(handType([2, 3, 2, 3, 2]) == 5);
    assert(handType([3, 2, 3, 2, 3]) == 5);

    assert(handType([3, 1, 3, 2, 3]) == 4);
    assert(handType([1, 1, 2, 1, 3]) == 4);
    assert(handType([3, 2, 2, 1, 2]) == 4);

    assert(handType([2, 1, 3, 2, 3]) == 3);
    assert(handType([1, 1, 2, 3, 3]) == 3);
    assert(handType([3, 1, 2, 1, 2]) == 3);

    assert(handType([4, 1, 3, 2, 3]) == 2);
    assert(handType([1, 1, 2, 4, 3]) == 2);
    assert(handType([3, 4, 2, 1, 2]) == 2);

    assert(handType([4, 1, 5, 2, 3]) == 1);
}

void main(string[] args)
{
    auto lines = stdin.byLineCopy.array
                      .sort!((a, b) => lessHand(
                          a[0..5].map!(x => card_map[x]).array,
                          b[0..5].map!(x => card_map[x]).array
                          ));

    lines.map!(x => x[6..$].to!long)
         .enumerate(1)
         .map!(x => x[0] * x[1])
         .sum
         .writeln;

}
