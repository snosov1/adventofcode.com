import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.format;
import std.concurrency;

void main(string[] args)
{
    immutable hoff = [
        'R'.to!int : [ 1,  0],
        'U'.to!int : [ 0,  1],
        'L'.to!int : [-1,  0],
        'D'.to!int : [ 0, -1],
        ];

    immutable toff = [

        [ 0, 0] : [0, 0],

        [ 1,  0] : [0, 0],
        [ 1,  1] : [0, 0],
        [ 0,  1] : [0, 0],
        [-1,  1] : [0, 0],
        [-1,  0] : [0, 0],
        [-1, -1] : [0, 0],
        [ 0, -1] : [0, 0],
        [ 1, -1] : [0, 0],

        [ 2,  0] : [ 1,  0],
        [ 2,  1] : [ 1,  1],
        [ 2,  2] : [ 1,  1],
        [ 1,  2] : [ 1,  1],
        [ 0,  2] : [ 0,  1],
        [-1,  2] : [-1,  1],
        [-2,  2] : [-1,  1],
        [-2,  1] : [-1,  1],
        [-2,  0] : [-1,  0],
        [-2, -1] : [-1, -1],
        [-2, -2] : [-1, -1],
        [-1, -2] : [-1, -1],
        [ 0, -2] : [ 0, -1],
        [ 1, -2] : [ 1, -1],
        [ 2, -2] : [ 1, -1],
        [ 2, -1] : [ 1, -1],
        ];


    auto t = [0, 0];
    auto h = [0, 0];
    auto off = [0, 0];
    auto visited = [
        t : true
        ];

    foreach (ref inst; stdin.byLine
                            .map!(x => [x.front, x[2..$].to!int]))
    {
        foreach (i; inst[1].iota)
        {
            h[] += hoff[inst[0]][];
            off[] = h[] - t[];
            off[] = toff[off];
            t[] += off[];
            visited[t.idup] = true;
        }
    }

    writeln(visited.length);
}
