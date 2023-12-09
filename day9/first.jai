#load "../utils.jai";

all_same :: (s : []int) -> bool {
    for 1..s.count-1 {
        if s[0] != s[it] return false;
    }
    return true;
}

nextn :: (s: []int) -> int {
    if all_same(s) return s[0];

    diff : [..] int;
    for 0..s.count-2 {
        array_add(*diff, s[it+1] - s[it]);
    }
    
    return s[s.count-1] + nextn(diff);
}

prevn :: (s: []int) -> int {
    if all_same(s) return s[0];

    diff : [..] int;
    for 0..s.count-2 {
        array_add(*diff, s[it+1] - s[it]);
    }
    return s[0] - prevn(diff);

}

part1 :: () {
    lines := get_input_as_lines("input.txt");

    s := 0;
    for l : lines {
        s += nextn(map(split(l, " "), str2int));
    }
    print("%\n", s);
}

part2 :: () {
    lines := get_input_as_lines("input.txt");

    s := 0;
    for l : lines {
        s += prevn(map(split(l, " "), str2int));
    }
    print("%\n", s);
}


main :: () {
    part1();
    part2();
}
