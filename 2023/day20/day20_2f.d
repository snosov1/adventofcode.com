import std;

void main(string[] args)
{
    // I manually restructure the original plot, by introducing the '+' block (essentially, merges '%' together)
    // I didn't figure out how to do this for the general case - hence, manual transformation for my input

    // in the end, this solution worked (although, I reused the original version in the end and only after that realized it)

    long[] out_masks = [0b111111111101, 0b111111111011, 0b111101000111, 0b111010010101];
    long[] in_masks = [0b11, 0b101, 0b10110001, 0b1101011];
    long[] states;
    states.length = out_masks.length;
    long[] final_bits;
    final_bits.length = states.length;

    long[][] maps;
    maps.length = states.length;
    long N = 1;
    foreach (i; 0..N)
    {
        foreach (j; 0..states.length)
        {
            long val = out_masks[j] + i * (0b1000000000000 - in_masks[j]);
            maps[j] ~= val;
        }
    }

    maps.map!(x => x[0]).fold!((a, b) => lcm(a, b))(1L).writeln;

    // long T = 0;
    // while (true)
    // {
    //     debug {
    //         writefln("%012b, %012b, %012b, %012b", states[0], states[1], states[2], states[3]);
    //     }

    //     int i = zip(states, out_masks).map!(x => x[1] - x[0] < 0 ? long.max : x[1] - x[0]).minIndex;
    //     long d = out_masks[i] - states[i];
    //     T += d;
    //     states[] += d;
    //     states[i] += in_masks[i];
    //     states[] &= 0b111111111111;

    //     foreach (j; 0..states.length)
    //     {
    //         if ((states[j] & out_masks[j]) == out_masks[j])
    //             final_bits[i] = 1;
    //         else
    //             final_bits[i] = 0;
    //     }

    //     if (final_bits.all!(x => x == 1))
    //     {
    //         writeln(T);
    //         break;
    //     }
    // }

    // foreach (T; sequence!((a, n) => n + 1))
    // {
    //     foreach (i; 0..states.length)
    //     {
    //         states[i]++;
    //         if ((states[i] & out_masks[i]) == out_masks[i])
    //         {
    //             states[i] += in_masks[i];
    //             final_bits[i] = 1;
    //         }
    //         else
    //             final_bits[i] = 0;

    //         states[i] &= 0b111111111111;
    //     }

    //     if (final_bits.all!(x => x == 1))
    //     {
    //         writeln(T);
    //         break;
    //     }
    // }
}
