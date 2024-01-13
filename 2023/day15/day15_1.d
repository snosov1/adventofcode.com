import std;

void main(string[] args)
{
    stdin.byLine.front.split(',')
         .map!(x => x.representation
                     .fold!((a, b) => (a + b) * 17 % 256)(0))
         .sum
         .writeln;
}
