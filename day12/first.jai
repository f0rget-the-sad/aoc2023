#load "../utils.jai";

Key :: struct {
    s : []u8;
    ints : []int;
    val : int;
}

hash_key :: (k : Key) -> u32 {
    h := sdbm_hash(k.s.data, k.s.count);
    h = sdbm_hash(k.ints.data, k.ints.count, h);
    return h;
}

compare :: (a : [] $T, b : [] T) -> bool {
    if a.count != b.count return false;
    for 0..a.count-1 {
        if a[it] != b[it] return false;
    }

    return true;
}

compare_key :: (a : Key, b : Key) -> bool {
    return compare(a.s, b.s) && compare(a.ints, b.ints);
}

memo : Table(Key, int, hash_key, compare_key);

count :: (s: []u8, ints: []int) -> int {
    //print("% %\n", s, ints);
    if s.count == 0 {
        if ints.count == 0 return 1;
        return 0;
    }

    if ints.count == 0 {
        if contains(s, #char "#") return 0;
        return 1;
    }

    key : = Key.{s=s, ints=ints, val=0};
    // XXX: find_or_add looks like had a bug, returned entry pointer is not valid?
    //val, is_new := find_or_add(*memo, key);
    //if !is_new return <<val;
    val, ok := table_find(*memo, key);
    if ok return val;

    result := 0;

    if s[0] == #char "." || s[0] == #char "?"
        result += count(trim_front(s, 1), ints);

    if s[0] == #char "#" || s[0] == #char "?" {
        if ints[0] <= s.count && !contains(trim_to(s, ints[0]), #char ".") &&
            (ints[0] == s.count || s[ints[0]] != #char "#")
            result += count(trim_front(s, ints[0] + 1), trim_front(ints, 1));
    }

    //<<val = result;
    table_add(*memo, key, result);

    return result;
}

part1 :: () {
    lines := get_input_as_lines("input.txt");

    s : s64 = 0;
    init(*memo);
    for l : lines {
        pts := split(l, " ");
        ints := map(split(pts[1], ","), str2int);
        curl := chars(pts[0]);
        lc := count(curl, ints);
        s += lc;
    }

    print("Res: %\n", s);
}

part2 :: () {
    lines := get_input_as_lines("input.txt");

    s : s64 = 0;
    init(*memo);
    for l : lines {
        pts := split(l, " ");
        ints := map(split(pts[1], ","), str2int);
        curl := chars(pts[0]);
        repeat_with(*curl, 5, #char "?");
        repeat(*ints, 5);
        lc := count(curl, ints);
        s += lc;
        //print("% % -> %\n", it_index, l, lc);

    }
    print("Res: %\n", s);
}

main :: () {
    part1();
    part2();
}
