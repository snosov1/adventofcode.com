import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;

struct claim_t {
    int id, x, y, w, h;
    this(string s) {
        s.formattedRead!"#%s @ %s,%s: %sx%s"(id, x, y, w, h);
    }
}

bool claimsDontIntersect(claim_t r1, claim_t r2)
{
    r1.id = r2.id = 0;
    if (r1 == r2)
        return true; // equal claims don't intersect

    return
        r2.x >= r1.x + r1.w ||
        r2.x + r2.w <= r1.x ||
        r2.y >= r1.y + r1.h ||
        r2.y + r2.h <= r1.y;
}

unittest {
    assert(!claimsDontIntersect(claim_t("#1 @ 1,3: 4x4"), claim_t("#2 @ 3,1: 4x4")));
    assert( claimsDontIntersect(claim_t("#1 @ 1,3: 4x4"), claim_t("#3 @ 5,5: 2x2")));
    assert( claimsDontIntersect(claim_t("#3 @ 5,5: 2x2"), claim_t("#2 @ 3,1: 4x4")));
}

void main(string[] args)
{
    auto input = stdin.byLine
                      .map!(x => claim_t(x.to!string))
                      .array;

    input.find!((x, y) => y.all!(a => claimsDontIntersect(a, x)))(input)
         .front
         .id
         .writeln;
}
