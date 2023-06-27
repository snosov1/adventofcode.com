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


    int[][] rope;
    rope.length = 10;
    rope.map!(x => [0, 0]).copy(rope);

    auto off = [0, 0];
    auto visited = [
        rope[0].idup : true
        ];

    foreach (ref inst; stdin.byLine
                            .map!(x => [x.front, x[2..$].to!int]))
    {
        //writeln(visited, " qq ", rope[$-1]);
        foreach (i; inst[1].iota)
        {
            rope[0][] += hoff[inst[0]][];
            foreach (k; 1..rope.length)
            {
                off[] = rope[k-1][] - rope[k][];
                off[] = toff[off];
                rope[k][] += off[];
            }
            visited[rope[$-1].idup] = true;
        }
    }

    writeln(visited.length);
}
