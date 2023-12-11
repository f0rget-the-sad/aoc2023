#load "../utils.jai";

Point :: struct {
    x,y : s64;
};

part1 :: (step : u32) {
    lines := get_input_as_lines("input.txt");

    if step != 1 step -= 1;

    // expand rows
    off_tbl_y : [..]u32;
    off_y : u32 = 0;
    array_add(*off_tbl_y, off_y);

    for l : lines {
        if !contains(l, #char "#") off_y += step;
        array_add(*off_tbl_y, off_y);
    }

    off_tbl_x : [..]u32;
    off_x : u32 = 0;
    array_add(*off_tbl_x, off_x);

    // expand colls
    for i : 0..lines[0].count-1 {
        for l : lines {
            if l[i] == #char "#" {
                array_add(*off_tbl_x, off_x);
                continue i;
            }
        }
        off_x += step;
        array_add(*off_tbl_x, off_x);
    }

    points : [..]Point;

    for l, y : lines {
        for x : 0..l.count-1 {
            c := l[x];
            if c == #char "#"
                array_add(*points,
                    Point.{x=x+off_tbl_x[x], y=y+off_tbl_y[y]});
        }
    }

    s := 0;
    for i : 0..points.count-2 {
        for j: i+1..points.count-1 {
            a := points[i];
            b := points[j];
            s += abs(a.x - b.x) + abs(a.y - b.y);
        }
    }

    print("%\n", s);
}

main :: () {
    part1(1);
    part1(1000000);
}
