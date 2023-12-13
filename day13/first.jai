#load "../utils.jai";

parse_group :: (lines : []string) -> int {
    line_len := lines[0].count;
    res: = 0;

    for mid : 1..lines.count-1 {
        toc := min(mid, lines.count-mid);
        for off : 0..toc-1 {
            if lines[mid-off-1] != lines[mid+off] continue mid;
        }
        return 100 * mid;
    }

    for mid : 1..line_len-1 {
        toc := min(mid, line_len-mid);
        for off: 0..toc-1 {
            for 0..lines.count-1 {
                if lines[it][mid-off-1] != lines[it][mid+off] continue mid;
            }
        }
        return mid;
    }

    assert(false);

    return 0;
}

part1 :: (file : string) {
    lines := get_input_as_lines(file, true);

    group : [..]string;

    s : s64 = 0;
    for l : lines {
        if l.count == 0 {
            s += parse_group(group);
            array_reset(*group);
            continue;
        }
        array_add(*group, l);
    }
    print("Res: %\n", s);
}


fix_group :: (lines : []string) -> int {
    line_len := lines[0].count;
    for mid : 1..lines.count-1 {
        smudge := 0;
        toc := min(mid, lines.count-mid);
        for off : 0..toc-1 {
            for 0..line_len-1 {
                if lines[mid-off-1][it] != lines[mid+off][it] {
                    if smudge != 0 continue mid;
                    smudge = 1;
                }
            }
        }
        if smudge return 100 * mid;
    }
    for mid : 1..line_len-1 {
        smudge := 0;

        toc := min(mid, line_len-mid);
        for off: 0..toc-1 {
            for 0..lines.count-1 {
                if lines[it][mid-off-1] != lines[it][mid+off] {
                    if smudge != 0 continue mid;
                    smudge = 1;
                }
            }
        }

        if smudge return mid;
    }


    assert(false);

    return 0;
}

part2 :: (file : string) {
    lines := get_input_as_lines(file, true);

    group : [..]string;

    s : s64 = 0;
    for l : lines {
        if l.count == 0 {
            s += fix_group(group);
            array_reset(*group);
            continue;
        }
        array_add(*group, l);
    }
    print("Res: %\n", s);
}

main :: () {
    part1("input.txt");
    part2("input.txt");
}
