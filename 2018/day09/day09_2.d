import std.stdio;
import std.container;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.typecons;
import std.math;

struct Node
{
    int payload;
    Node *next;
    Node *prev;
}

int main(string[] args)
{
    auto input = readln.split.array;
    auto n = input[0].to!int;
    auto m = input[6].to!int;

    auto curr_node = new Node;
    curr_node.payload = 0;
    curr_node.next = curr_node;
    curr_node.prev = curr_node;
    int curr_player = 0;

    auto scores = new long[n];

    for (int i = 1; i <= m; i++)
    {
        if (i % 23 != 0)
        {
            curr_node = curr_node.next;
            auto node = new Node;
            node.payload = i;
            node.prev = curr_node;
            node.next = curr_node.next;
            curr_node.next = node;
            node.next.prev = node;
            curr_node = curr_node.next;
        }
        else
        {
            scores[curr_player] += i;

            for (int j = 0; j < 7; j++)
                curr_node = curr_node.prev;

            scores[curr_player] += curr_node.payload;
            curr_node.prev.next = curr_node.next;
            curr_node.next.prev = curr_node.prev;
            curr_node = curr_node.next;
        }
        curr_player = (curr_player + 1) % n;
    }

    scores.maxElement.writeln;

    return 0;
}
