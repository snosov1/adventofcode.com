import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.format;
import std.math;

void main(string[] args)
{
    auto input = (){
        return [stdin.byLine.front.find(": ")[2..$]
                    .filter!(x => x != ' ')
                    .to!long];
    };

    auto time = input();
    auto distance = input();

    time.writeln;
    distance.writeln;

    debug {
        int i = 0;
        auto t = time.array;
        iota(t[i]+1).map!(h => h*(t[i] - h)).writeln;
    }

    enum eps = 1e-7;
    zip(time, distance).map!(x => floor((x[0] + sqrt(x[0]*x[0] - 4.0*x[1])) * 0.5 - eps).to!long
                                  -ceil((x[0] - sqrt(x[0]*x[0] - 4.0*x[1])) * 0.5 + eps).to!long
                                  + 1)
                       .fold!((a, b) => a * b)(1L)
                       .writeln;

}
