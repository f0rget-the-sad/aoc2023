#load "../utils.jai";

check_nb :: (lines : []string, _x: int, _y: int) -> bool {
    n := lines[0].count;
    for i : -1..1 {
        for j : -1..1 {
            x := _x + i;
            y := _y + j;
            if x < 0 || x >= lines.count continue;
            if y < 0 || y >= n continue;

            if !is_digit(lines[x][y]) && lines[x][y] != #char "." {
                return true;
            }

        }
    }

    return false;
}

check_star :: (lines : []string, _x: u16, _y: u16) -> u32 {
    n := lines[0].count;
    for i : -1..1 {
        for j : -1..1 {
            x : = _x + i;
            y : = _y + j;
            if x < 0 || x >= lines.count continue;
            if y < 0 || y >= n continue;

            if lines[x][y] == #char "*" {
                return xx (x << 16 | y);
            }

        }
    }

    return 0;
}

part1 :: () {
    lines := get_input_as_lines("input.txt");
    s : u32 = 0;
    n : u32 = 0;
    ind : bool = false;
    good : bool = false;

    for lid : 0..lines.count-1 {
        l := lines[lid];
        for cid : 0..l.count-1 {
            c := l[cid];
            if is_digit(c) {
                n = n * 10 + (c - #char "0");
                ind = true;
                if !good {
                    good = check_nb(lines, lid, cid);
                }
            } else if ind {
                if good s += n;
                n = 0;
                ind = false;
                good = false;
            }
        }
    }

    // handle last digit if any
    if ind && good {
        s += n;
    }

    print("part 1: %\n", s);
}

part2 :: () {
    lines := get_input_as_lines("input.txt");
    s : u32 = 0;
    n : u32 = 0;
    ind : bool = false;
    star : u32 = 0;

    Res :: struct {
        v: u32;
        cnt: u32;
    };

    table: Table(u32, Res);

    for l, lid : lines {
        //XXX: string is not directly iterable...
        for cid : 0..l.count-1 {
            c := l[cid];
            if is_digit(c) {
                n = n * 10 + (c - #char "0");
                ind = true;
                if !star {
                    star = check_star(lines, cast(u16) lid, cast(u16) cid);
                } else {
                    // check if it's possible to have two stars around same
                    // number
                    star2 := check_star(lines, cast(u16) lid, cast(u16) cid);
                    if star2 != 0 && star2 != star {
                        print("star1 % star2 %\n", star, star2);
                        print("found two stars at % %\n", lid, cid);
                        exit(1);
                    }
                }
            } else if ind {
                if star {
                    //print("Adding %\n", star);
                    value := find_or_add(*table, star);
                    value.cnt += 1;
                    if value.cnt == 1 value.v = n;
                    if value.cnt == 2 value.v *= n;
                }

                n = 0;
                ind = false;
                star = 0;
            }
        }
    }

    // handle last digit if any
    if ind && star {
        value := find_or_add(*table, star);
        value.cnt += 1;
        if value.cnt == 1 value.v = n;
        if value.cnt == 2 value.v *= n;
    }

    for value: table {
        if value.cnt == 2 s += value.v;
    }

    print("part 2: %\n", s);
}

main :: () {
    // part 1: 553079
    part1();
    // 84363105
    part2();
}
