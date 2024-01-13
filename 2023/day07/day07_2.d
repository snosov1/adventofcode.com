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
    'J': 1, // JOKER!
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

int handTypeJoker(int[] hand)
{
    auto h = hand.dup;
    auto hj = h.find(card_map['J']);

    if (hj.empty)
        return handType(hand);

    // optimize for higher number of Js
    int js = hand.count(card_map['J']);
    if (js >= 4)
        return handType([1, 1, 1, 1, 1]);

    int m = 0;
    foreach (c; card_map.keys.filter!(x => x != 'J'))
    {
        hj.front = card_map[c];

        debug {
            writeln(h);
        }

        int t = handTypeJoker(h);
        if (t > m)
            m = t;
    }

    return m;
}

unittest {
    alias htj = (h){ return h.map!(x => card_map[x]).array.handTypeJoker; };

    writeln(htj("32T3K"));
    writeln(htj("T55J5"));
    writeln(htj("KK677"));
    writeln(htj("KTJJT"));
    writeln(htj("QQQJA"));
}

bool lessHand(int[] l, int[] r)
{
    auto lht = l.handTypeJoker;
    auto rht = r.handTypeJoker;

    if (lht < rht)
        return true;

    if (lht > rht)
        return false;

    return cmp(l, r) < 0;
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
