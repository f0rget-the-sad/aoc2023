#load "../utils.jai";

part1 :: () {
	lines := get_input_as_lines("input.txt");

	times := map(aoc_split(aoc_split(lines[0], "Time:")[0], " "), str2int);
	distances := map(aoc_split(aoc_split(lines[1], "Distance:")[0], " "), str2int);

	print("times: %\n", times);
	print("dist: %\n", distances);

	res := 1;
	for t, i : times {
		cnt := 0;
		for 1..t-1 {
			speed := it;
			time := t - it;
			if speed * time > distances[i] cnt += 1;
		}
		res *= cnt;
	}

	print("part1: %\n", res);

}

part2 :: () {
	lines := get_input_as_lines("input.txt");

	time := parse_int(*join(..aoc_split(aoc_split(lines[0], "Time:")[0], " ")));
	dist := parse_int(*join(..aoc_split(aoc_split(lines[1], "Distance:")[0], " ")));

	cnt := 0;
	for 1..time-1 {
		speed := it;
		time_left := time - it;
		if speed * time_left > dist cnt += 1;
	}

	print("part2: %\n", cnt);

}

main :: () {
	part1();
	part2();
}
