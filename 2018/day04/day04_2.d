import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;

enum Action {
    BEGINS_SHIFT,
    WAKES_UP,
    FALLS_ASLEEP
};

struct record_t {
    int id;
    DateTime d;
    Action a;

    this(string s) {
        int year, month, day, hour, minute;
        s.formattedRead!"[%s-%s-%s %s:%s] "(year, month, day, hour, minute);
        d = DateTime(year, month, day, hour, minute);
        auto splitted = s.split(" ");
        if (splitted[0] == "wakes")
            a = Action.WAKES_UP;
        else if (splitted[0] == "falls")
            a = Action.FALLS_ASLEEP;
        else
        {
            a = Action.BEGINS_SHIFT;
            id = splitted[1][1..$].to!int;
        }
    }
}

void main(string[] args)
{
    auto input = stdin.byLine
                      .map!(x => record_t(x.to!string))
                      .array
                      .sort!((x, y) => x.d < y.d)
                      .chunkBy!(x => x.id)
                      .map!(x => x[1].array)
                      .array;

    int curr_id = 0;
    int[][int] sleep_log;
    for (int i = 0; i < input.length; i++)
    {
        if (input[i].length == 1)
        {
            curr_id = input[i][0].id;
            continue;
        }

        auto log = sleep_log.get(curr_id, new int[](60));
        foreach (sleepy_time; input[i].map!(a => a.d.minute)
                                      .chunks(2))
            ++log[sleepy_time[0]..sleepy_time[1]];
        sleep_log[curr_id] = log;
    }

    auto sleepy_guard = sleep_log.byKeyValue
                                 .maxElement!(x => x.value
                                                    .maxElement);

    writeln(sleepy_guard.key * sleep_log[sleepy_guard.key].maxIndex);
}
