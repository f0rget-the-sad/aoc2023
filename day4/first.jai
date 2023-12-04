#load "../utils.jai";

part1 :: () {
    lines := get_input_as_lines("input.txt");
	s := 0;


	for l : lines {
		numbers := aoc_split(l, " | ");
		// XXX: no hash set?
		win_set : Table(int, bool);
		for n : aoc_split(numbers[1], " "){
			val := to_integer(n);
			table_add(*win_set, val, true);
		}

		count := 0;
		for n : aoc_split(aoc_split(numbers[0], ":")[1], " ") {
			if table_contains(*win_set, to_integer(n)) count += 1;
		}
		if count s += (1 << (count - 1));

	}

	print("part1: %\n", s);
}

part2 :: () {
    lines := get_input_as_lines("input.txt");
	s := 0;

	win_cnt : [..] int;
	array_resize(*win_cnt, lines.count, true);

	for < l, lid : lines {
		numbers := aoc_split(l, " | ");
		// XXX: no hash set?
		win_set : Table(int, bool);
		for n : aoc_split(numbers[1], " "){
			val := to_integer(n);
			table_add(*win_set, val, true);
		}

		count := 0;
		for n : aoc_split(aoc_split(numbers[0], ":")[1], " ") {
			if table_contains(*win_set, to_integer(n)) count += 1;
		}

		// cache win count
		cur_win := count;
		for 1..count {
			cur_win += win_cnt[lid + it];
		}
		win_cnt[lid] = cur_win;
	}

	// total wins
	s += lines.count;
	for win_cnt {
		s+=it;
	}

	print("part2: %\n", s);
}

main :: () {
	part1();
	part2();
}
