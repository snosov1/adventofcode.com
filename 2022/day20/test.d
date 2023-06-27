import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.range;
import std.format;
import std.typecons;
import std.concurrency;
import std.exception;
import std.math;
import std.numeric;
import std.variant;

int main(string[] args)
{
    auto a = [3, 6, 2, 1, 5, 4, 0];

    auto indicies = iota(3);
    auto ai = indexed(a, indicies);
    ai = indexed(ai, iota(2));

    // auto indicies = iota(3);
    // RandomAccessFinite!int ai = indexed(a, indicies).inputRangeObject;
    // ai = indexed(ai, iota(2)).inputRangeObject;

    // auto ai = indexed(a, indicies);
    // //ai = indexed(ai, iota(2));
    // ai = indexed(ai.source, indexed(ai.indices, iota(2)));

    writeln(ai);

    return 0;
}

// int main(string[] args)
// {
//     auto a = [3, 6, 2, 1, 5, 4, 0];

//     auto indicies = iota(3);
//     Variant ai;
//     ai = indexed(a, indicies);
//     ai = indexed(ai, iota(2));

//     writeln(ai);

//     return 0;
// }
