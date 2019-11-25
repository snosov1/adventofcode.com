import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.utf;
import std.typecons;
import std.math;

struct cell_t {
    char c;
    char prev;

    this(char c)
    {
        this.c = c;
        this.prev = c;
    }
}

enum arrows = [
    '>' : tuple( 0,  1),
    '^' : tuple(-1,  0),
    '<' : tuple( 0, -1),
    'v' : tuple( 1,  0)
    ];

enum identity = [
    '>' : '>',
    '^' : '^',
    '<' : '<',
    'v' : 'v'
    ];

enum movein = [
    '|'  : identity,
    '-'  : identity,
    '\\' : [
        '>' : 'v',
        '^' : '<',
        '<' : '^',
        'v' : '>'
        ],
    '/'  : [
        '>' : '^',
        '^' : '>',
        '<' : 'v',
        'v' : '<'
        ],
    ];

enum turn = [
    [
        '<' : 'v',
        '^' : '<',
        '>' : '^',
        'v' : '>'
    ],
    identity,
    [
        '<' : '^',
        '^' : '>',
        '>' : 'v',
        'v' : '<'
    ]
    ];

enum cw = [
    '>' : 'v',
    '^' : '>',
    '<' : '^',
    'v' : '<'
    ];

enum acw = [
    '>' : 'v',
    '^' : '>',
    '<' : '^',
    'v' : '<'
    ];



int main(string[] args)
{
    auto field = stdin.byLine
                      .map!(a => a.map!(b => cell_t(cast(char)b))
                                  .array)
                      .array;

    for (int i = 0; i < field.length; i++)
    {
        for (int j = 0; j < field[i].length; j++)
        {
            auto c = field[i][j];
            if (c.c in arrows)
            {
                if ((j - 1 < 0                || field[j-1].c == ' ' || field[j-1].c == '|') &&
                    (j + 1 >= field[i].length || field[j+1].c == ' ' || field[j+1].c == '|'))
                {
                    field[i][j].prev = '|';
                }

                if ((i - 1 < 0             || field[i-1].c == ' ' || field[i-1].c == '-') &&
                    (i + 1 >= field.length || field[i+1].c == ' ' || field[i+1].c == '-'))
                {
                    field[i][j].prev = '-';
                }
            }
        }
    }


    return 0;
}
