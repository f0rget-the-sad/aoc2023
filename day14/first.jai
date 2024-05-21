#load "../utils.jai";

part1 :: () {
    lines : [..] string;
    orig := array_copy(*lines, get_input_as_lines("test.txt"));

    /* XXX: is there a simpler way to generate string? */
    builder: String_Builder;
    init_string_builder(*builder);
    for 0..lines[0].count-1 append(*builder, "#");
    north_border := builder_to_string(*builder);
    array_insert_at(*lines, north_border, 0);

    total_load := 0;
    for gl, gli : lines {
        for ci: 0..lines[0].count-1 {
            load := lines.count-gli-1;
            if gl[ci] != #char "#"
                continue;

            for li : gli+1..lines.count-1 {
                l := lines[li];
                if l[ci] == #char "#"
                    break;
                if l[ci] == #char "O" {
                    total_load += load;
                    load -= 1;
                }
            }
        }
    }
    print("total_load: %\n", total_load);
}

move_north:: (lines : [] string) {
    for gli : 1..lines.count-1 {
        gl := lines[gli];
        for ci: 0..lines[0].count-1 {
            if gl[ci] != #char "O"
                continue;
            gl[ci] = #char ".";
            for < li : gli-1..0 {
                l := lines[li];
                if l[ci] == #char "#" || l[ci] == #char "O" {
                    lines[li+1][ci] = #char "O";
                    break;
                }
            }
        }
    }
}

move_south:: (lines : [] string) {
    for < gli : lines.count-2..0 {
        gl := lines[gli];
        for ci: 0..lines[0].count-1 {
            if gl[ci] != #char "O"
                continue;
            gl[ci] = #char ".";
            for li : gli+1..lines.count-1 {
                l := lines[li];
                if l[ci] == #char "#" || l[ci] == #char "O" {
                    lines[li-1][ci] = #char "O";
                    break;
                }
            }
        }
    }
}

move_west:: (lines : [] string) {
    for gli : 1..lines.count-1 {
        gl := lines[gli];
        for ci: 0..lines[0].count-1 {
            if gl[ci] != #char "O"
                continue;
            gl[ci] = #char ".";
            for < ni : ci-1..0 {
                if gl[ni] == #char "#" || gl[ni] == #char "O" {
                    gl[ni+1] = #char "O";
                    break;
                }
            }
        }
    }
}

move_east:: (lines : [] string) {
    for gli : 1..lines.count-1 {
        gl := lines[gli];
        for < ci: lines[0].count-2..0 {
            if gl[ci] != #char "O"
                continue;
            gl[ci] = #char ".";
            for ni : ci+1..lines.count-1 {
                if gl[ni] == #char "#" || gl[ni] == #char "O" {
                    gl[ni-1] = #char "O";
                    break;
                }
            }
        }
    }
}

display_lines :: (lines : [] string, info: bool = true) {
    if !info return;
    for l : lines {
        print("%\n", l);
    }
}

cycle :: (lines : [] string, info: bool) {
    move_north(lines);
    display_lines(lines, info);

    move_west(lines);
    display_lines(lines, info);

    move_south(lines);
    display_lines(lines, info);

    move_east(lines);
    display_lines(lines, info);
}

calc :: (lines : [] string) -> s64 {
    total_load := 0;
    load := lines.count-1;
    for l, li : lines {
        for ci: 0..lines[0].count-1 {
            if l[ci] == #char "O"
                total_load += load;
        }
        load -= 1;
    }
    return total_load;
}

part2 :: () {
    orig := get_input_as_lines("input.txt");

    /* XXX: is there a simpler way to generate string? */

    /* put borders around the input */
    builder: String_Builder;
    init_string_builder(*builder);
    for 0..orig[0].count+1 append(*builder, "#");
        append(*builder, "\n");
    for l : orig {
        append(*builder, "#");
        append(*builder, l);
        append(*builder, "#");
        append(*builder, "\n");
    }
    for 0..orig[0].count+1 append(*builder, "#");

    bordered := builder_to_string(*builder);
    lines := split(bordered, "\n");


    set : Table(string, int);
    table_add(*set, join(.. lines), 0);

    start_off := 0;
    period : = 0;

    /* idea is to find repeating pattern and obuse it to skip iterations */
    X :: 1000000000;
    for 0..1000 {
        cycle(lines, false);
        ns := join(.. lines);
        val, found := table_find(*set, ns);
        if found {
            print("BUBLICATOS at % with %\n", it, val);
            // [staring offset] [pattern] [pattern] .. [pattern] [reminder..]
            rem := (X - val) % (it - val + 1);
            for 0..rem-1 {
                cycle(lines, false);
            }
            print("res = %\n", calc(lines));
            break;
        }
        table_add(*set, ns, it+1);
    }

}

main :: () {
    part1();
    part2();
}
