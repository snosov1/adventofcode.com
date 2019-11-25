// --- Day 17: No Such Thing as Too Much ---

// The elves bought too much eggnog again - 150 liters this time. To fit it all
// into your refrigerator, you'll need to move it into smaller containers. You
// take an inventory of the capacities of the available containers.

// For example, suppose you have containers of size 20, 15, 10, 5, and 5
// liters. If you need to store 25 liters, there are four ways to do it:

// 15 and 10
// 20 and 5 (the first 5)
// 20 and 5 (the second 5)
// 15, 5, and 5

// Filling all containers entirely, how many different combinations of
// containers can exactly fit all 150 liters of eggnog?

// --- Part Two ---

// While playing with all the containers in the kitchen, another load of eggnog
// arrives! The shipping and receiving department is requesting as many
// containers as you can spare.

// Find the minimum number of containers that can exactly fit all 150 liters of
// eggnog. How many different ways can you fill that number of containers and
// still hold exactly 150 litres?

// In the example above, the minimum number of containers was two. There were
// three ways to use that many containers, and so the answer there would be 3.

import std.stdio;
import std.algorithm;

int main(string[] args)
{
    int[] sizes =
    [
        43, 3, 4, 10, 21,
        44, 4, 6, 47, 41,
        34, 17, 17, 44, 36,
        31, 46, 9, 27, 38
    ];

    int vol = 150;
    int ret = 0;

    int[] count = new int[sizes.length];

    for (int i = 0; i < (1 << sizes.length); i++)
    {
        int n = 0;
        int capacity = 0;
        for (int j = 0; j < sizes.length; j++)
        {
            if (i & (1 << j))
            {
                capacity += sizes[j];
                n++;
            }
        }

        if (capacity == vol)
        {
            count[n]++;
            ret++;
        }
    }

    for (int i = 0; i < count.length; i++)
    {
        if (count[i] != 0)
        {
            writeln(count[i]);
            break;
        }
    }

    //writeln(count.minCount[1]);

    //writeln(ret);

    return 0;
}
