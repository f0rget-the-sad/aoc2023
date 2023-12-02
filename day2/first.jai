#load "../utils.jai";

MAX_RED   :: 12;
MAX_GREEN :: 13;
MAX_BLUE  :: 14;

part1 :: () -> int {
    s := 0;
    lines := get_input_as_lines();
    for l : lines {
        found, left, right := split_from_right(l, "Game ");
        found, left, right = split_from_right(right, #char":");
        gid, ok := parse_int(*left);
        assert(ok);

        right = trim(right);
        parts := split(right, "; ");
        for p: parts {
            for cube : split(p, ", ") {
                n_color := split(cube, " ");
                n, ok := parse_int(*n_color[0]);
                assert(ok);

                if (n_color[1] == "red" && n > MAX_RED) ||
                   (n_color[1] == "green" && n > MAX_GREEN) ||
                   (n_color[1] == "blue" && n > MAX_BLUE) {
                    continue l;
                }
            }
        }
        s += gid;
    }
    print("part1: %\n", s);
    return s;
}

part2 :: () -> int {
    s := 0;
    lines := get_input_as_lines();
    for l : lines {
        found, left, right := split_from_right(l, "Game ");
        found, left, right = split_from_right(right, #char":");
        gid, ok := parse_int(*left);
        assert(ok);

        right = trim(right);
        parts := split(right, "; ");
        max_r, max_g, max_b := 1, 1, 1;
        for p: parts {
            for cube : split(p, ", ") {
                n_color := split(cube, " ");
                n, ok := parse_int(*n_color[0]);
                assert(ok);

                if (n_color[1] == "red")
                    max_r = max(max_r, n);
                else if (n_color[1] == "green")
                    max_g = max(max_g, n);
                else if (n_color[1] == "blue")
                    max_b = max(max_b, n);
            }
        }
        s += (max_r * max_g * max_b);
    }
    print("part2: %\n", s);
    return s;
}

main :: () {
    // 2447
	part1();
    // 56322
	part2();
}
