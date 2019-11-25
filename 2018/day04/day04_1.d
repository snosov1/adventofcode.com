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
    int[int] sleep_time;
    for (int i = 0; i < input.length; i++)
    {
        if (input[i].length == 1)
        {
            curr_id = input[i][0].id;
            continue;
        }

        auto s = input[i].chunks(2)
                         .map!(x => x[1].d.minute - x[0].d.minute)
                         .sum;

        foreach (ref j; input[i])
            j.id = curr_id;

        sleep_time[curr_id] = sleep_time.get(curr_id, 0) + s;
    }

    auto sleepy_guard = sleep_time.byKeyValue
                                  .maxElement!(x => x.value);

    auto sleep_log = new int[](60);
    foreach (schedule; input.filter!(a => a.length > 1 && a[0].id == sleepy_guard.key))
        foreach (sleepy_time; schedule.map!(a => a.d.minute)
                                      .chunks(2))
            ++sleep_log[sleepy_time[0]..sleepy_time[1]];

    writeln(sleepy_guard.key * sleep_log.maxIndex);
}
