#load "../utils.jai";

part1 :: () {
    lines : [..] string;
    orig := array_copy(*lines, get_input_as_lines("input.txt"));

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

main :: () {
    part1();
}
