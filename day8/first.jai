#load "../utils.jai";


get_dir :: (path: string, id: int) -> int {
	id = id % path.count;
	if path[id] == #char "L" return 0;
	return 1;
}


part1 :: () {
	lines := get_input_as_lines("input.txt");
	path: = lines[0];

	table : Table(string, [2]string);

	for 2..lines.count-1 {
		l := lines[it];
		kv:= split(l, " = ");
		values := trim(kv[1], "()");
		vs := split(values, ", ");
		// XXX: is there a better way to convert between dyn and const arrays?
		va := string.[vs[0], vs[1]];
		table_add(*table, kv[0], va);
	}

	id := 0;
	loc : string = "AAA";
	while loc != "ZZZ" {
		val, found := table_find(*table, loc);
		assert(found);
		loc = val[get_dir(path, id)];
		id += 1;
	}

	print("part1: %\n", id);

}

part2 :: () {
	lines := get_input_as_lines("input.txt");
	path: = lines[0];

	table : Table(string, [2]string);

	for 2..lines.count-1 {
		l := lines[it];
		kv:= split(l, " = ");
		values := trim(kv[1], "()");
		vs := split(values, ", ");
		// XXX: is there a better way to convert between dyn and const arrays?
		va := string.[vs[0], vs[1]];
		table_add(*table, kv[0], va);
	}

	starts : [..] string;

	for v, k : table {
		if contains(k, #char "A") array_add(*starts, k);
	}

	res : [..]int;

	for starts {
		loc := it;
		id := 0;
		while !contains(loc, #char "Z"){
			val, found := table_find(*table, loc);
			assert(found);
			loc = val[get_dir(path, id)];
			id += 1;
		}
		array_add(*res, id);
	}

	ans := res[0];

	for 1..res.count-1 {
		ans = lcm(ans, res[it]);
	}

	print("part2: %\n", ans);

}

main :: () {
	part1();
	part2();
}

