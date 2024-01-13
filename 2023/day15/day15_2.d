import std;

void main(string[] args)
{
    Tuple!(string, int)[][] boxes;
    boxes.length = 256;

    foreach (step; stdin.byLine.front.split(','))
    {
        auto focal = step.findAmong("=-");
        auto label = step[0..$-focal.length];
        auto hash = label.representation
                         .fold!((a, b) => (a + b) * 17 % 256)(0);

        if (focal.front == '-')
        {
            boxes[hash] = boxes[hash].remove!(x => x[0] == label);
        }
        else
        {
            auto lens = boxes[hash].find!(x => x[0] == label);

            if (lens.empty)
                boxes[hash] ~= tuple(label.idup, focal[1..$].to!int);
            else
                lens.front[1] = focal[1..$].to!int;
        }
    }

    boxes.enumerate
         .map!(x => (x[0] + 1) * x[1].enumerate.map!(y => (y[0] + 1) * y[1][1]).sum)
         .sum
         .writeln;
}
