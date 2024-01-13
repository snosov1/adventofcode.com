import std;

void main(string[] args)
{
    enum code = [
        0 : 'R',
        1 : 'D',
        2 : 'L',
        3 : 'U',
        ];

    auto input = stdin.byLineCopy
                      .map!((x){
                          char dir;
                          long dist;
                          long color;

                          x.formattedRead("%s %d (#%x)", &dir, &dist, &color);

                          dist = color & 0xFFFFF0;
                          dist >>= 4;
                          dir = code[color & 0xF];

                          return tuple(dir, dist, color);
                      }).array;

    // auto input = stdin.byLineCopy
    //                   .map!((x){
    //                       char dir;
    //                       int dist;
    //                       int color;

    //                       x.formattedRead("%s %d (#%x)", &dir, &dist, &color);

    //                       return tuple(dir, dist, color);
    //                   }).array;

    debug {
        input.writeln;
    }
    alias Tuple!(long[], long[], char) line_t;

    line_t[] lines;
    long[] pos;
    pos.length = 2;

    enum offs = [
        'U' : [ 1,  0],
        'D' : [-1,  0],
        'L' : [ 0, -1],
        'R' : [ 0,  1],
        ];

    char[Tuple!(long, long)] corners;

    enum bends = [
        tuple('R', 'U') : 'J',
        tuple('R', 'D') : '7',
        tuple('L', 'U') : 'L',
        tuple('L', 'D') : 'F',

        tuple('U', 'R') : 'F',
        tuple('D', 'R') : 'L',
        tuple('U', 'L') : '7',
        tuple('D', 'L') : 'J',

        ];

    foreach (row; input)
    {
        auto npos = pos.dup;
        zip(npos, offs[row[0]]).map!(x => x[0] + x[1] * row[1]).copy(npos);
        lines ~= tuple(pos, npos.dup, row[0]);
        if (lines.length > 1)
            corners[tuple(pos[0], pos[1])] = bends[tuple(lines[$-2][2], lines[$-1][2])];
        pos = npos;
    }

    corners[tuple(lines[0][0][0], lines[0][0][1])] = bends[tuple(lines[$-1][2], lines[0][2])];

    auto vlines = lines.filter!(x => x[2] == 'U' || x[2] == 'D').array;
    vlines.sort!((a, b) => a[0][1] < b[0][1]);

    long oi = vlines.map!(x => min(x[0][0], x[1][0])).minElement;
    long ni = vlines.map!(x => max(x[0][0], x[1][0])).maxElement;

    long oj = vlines.map!(x => min(x[0][1], x[1][1])).minElement;
    long nj = vlines.map!(x => max(x[0][1], x[1][1])).maxElement;

    long n = ni - oi + 1;

    enum sm = [
        tuple(0, '|') : 3,
        tuple(0, 'L') : 4,
        tuple(0, 'F') : 5,

        tuple(1, 'J') : 6,
        tuple(1, '7') : 7,

        tuple(2, 'J') : 8,
        tuple(2, '7') : 9,

        tuple(3, '|') : 0,
        tuple(3, 'L') : 1,
        tuple(3, 'F') : 2,


        tuple(4, 'J') : 10,
        tuple(4, '7') : 11,


        tuple(5, 'J') : 12,
        tuple(5, '7') : 13,

        tuple(6, '|') : 0,
        tuple(6, 'L') : 1,
        tuple(6, 'F') : 2,

        tuple(7, '|') : 3,
        tuple(7, 'L') : 4,
        tuple(7, 'F') : 5,

        tuple(8, '|') : 3,
        tuple(8, 'L') : 4,
        tuple(8, 'F') : 5,

        tuple(9, '|') : 0,
        tuple(9, 'L') : 1,
        tuple(9, 'F') : 2,

        // ------------

        tuple(10, '|') : 3,
        tuple(10, 'L') : 4,
        tuple(10, 'F') : 5,

        tuple(11, '|') : 0,
        tuple(11, 'L') : 1,
        tuple(11, 'F') : 2,

        tuple(12, '|') : 0,
        tuple(12, 'L') : 1,
        tuple(12, 'F') : 2,

        tuple(13, '|') : 3,
        tuple(13, 'L') : 4,
        tuple(13, 'F') : 5,
        ];

    enum ss = [
        tuple('|', '|') : 0,
        tuple('|', 'L') : 1,
        tuple('|', 'F') : 2,

        tuple('L', 'J') : 10,
        tuple('L', '7') : 11,

        tuple('F', 'J') : 12,
        tuple('F', '7') : 13,
        ];

    long ans = 0;
    foreach (i; 0..n)
    {
        auto cand = vlines.filter!(x => i + oi >= min(x[0][0], x[1][0]) && i + oi <= max(x[0][0], x[1][0]));

        debug {
            writeln(i + oi);
            vlines.filter!(x => i + oi >= min(x[0][0], x[1][0]) && i + oi <= max(x[0][0], x[1][0])).writeln;
        }
        if (cand.empty)
            continue;

        auto sc = cand.slide(2);
        auto state = -1;
        int k = 0;
        foreach (p; sc)
        {
            auto c = p.array;
            auto l = tuple(i + oi, c[0][0][1]);
            auto r = tuple(i + oi, c[1][0][1]);

            if (state == -1)
                state = ss[tuple(corners.get(l, '|'), corners.get(r, '|'))];
            else
                state = sm[tuple(state, corners.get(r, '|'))];

            debug {
                writeln("state = ", state);
            }

            if (state == 0 || state == 1 || state == 2)
            {
                ans += r[1] - l[1];
            }
            else if (state == 3 || state == 4 || state == 5)
            {
                ans++;
            }
            else if (state >= 6)
            {
                ans += r[1] - l[1];
            }
            else
            {
                assert(0);
            }

            debug {
                writeln("ans = ", ans);
            }
        }

        if (state == 0 || state >= 6)
        {
            ans++;
        }

        debug {
            writeln("ans = ", ans);
        }
    }

    debug {
        lines.writeln;
        corners.writeln;
        vlines.writeln;
    }
    ans.writeln;
}
