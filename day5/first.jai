#load "../utils.jai";

part1 :: () {
	lines := get_input_as_lines("input.txt", true);

	seeds := aoc_split(aoc_split(lines[0], "seeds: ")[0], " ");

	Range :: struct {
		dst: u64;
		src: u64;
		cnt: u64;
	};

	Map :: struct {
		ranges: [..] Range;
	};

	all_mapings : [..] Map;

	map := New(Map);

	for lid : 2..lines.count-1 {
		l := lines[lid];

		if contains(l, #char ":") {
			map = New(Map);
			continue;
		};

		if l.count == 0 {
			array_add(*all_mapings, map);
			continue;
		}

		rl := aoc_split(l, " ");
		range := Range.{
			dst = aoc_parse_int(*rl[0], u64),
			src = aoc_parse_int(*rl[1], u64),
			cnt = aoc_parse_int(*rl[2], u64),
		};
		array_add(*map.ranges, range);
	}

	dst_from_map :: (m: Map, src: u64) -> u64 {
		for r : m.ranges {
			if src >= r.src && src < r.src + r.cnt {
				return r.dst + (src - r.src);
			}
		}

		return src;
	}

	min_loc := U64_MAX;

	for s : seeds {
		loc := aoc_parse_int(*s, u64);
		for m : all_mapings {
			loc = dst_from_map(m, loc);
		}
		min_loc = min(min_loc, loc);
	}

	print("part1: %\n", min_loc);
}

part2 :: () {
	lines := get_input_as_lines("input.txt", true);

	seeds := aoc_split(aoc_split(lines[0], "seeds: ")[0], " ");

	Range :: struct {
		start: u64;
		end  : u64;
	};

	range_intersection :: (a: Range, b: Range) -> present: bool, intersection: Range {
		if b.start > a.end || a.start > b.end return false, Range.{};
		return true, Range.{start = max(a.start, b.start), end = min(a.end, b.end)};
	}

	Pair :: struct {
		src: Range;
		dst: Range;
	};

	Map :: struct {
		ranges: [..] Pair;
	};

	all_mapings : [..] Map;

	map := New(Map);
	for lid : 2..lines.count-1 {
		l := lines[lid];

		if contains(l, #char ":") {
			map = New(Map);
			continue;
		};

		if l.count == 0 {
			array_add(*all_mapings, map);
			continue;
		}

		rl := aoc_split(l, " ");
		dst := aoc_parse_int(*rl[0], u64);
		src := aoc_parse_int(*rl[1], u64);
		cnt := aoc_parse_int(*rl[2], u64);

		p := Pair.{
			src = Range.{start = src, end = src+cnt-1},
			dst = Range.{start = dst, end = dst+cnt-1},
		};
		array_add(*map.ranges, p);
	}

	seed_ranges : [..]Range;
	for sid : 0..seeds.count-1 {
		sr : Range;
		sr.start = aoc_parse_int(*seeds[sid], u64);
		sid += 1;
		sr.end = sr.start + aoc_parse_int(*seeds[sid], u64) - 1;
		array_add(*seed_ranges, sr);
	}

	trace_range :: (in: Range, m : Map) -> [..]Range {
		res : [..]Range;
		cov : [..]Range;
		for pair : m.ranges {
			ok, inter := range_intersection(in, pair.src);
			if ok {
				array_add(*cov, inter);
				sd := pair.dst.start + (inter.start - pair.src.start);
				ed := sd + (inter.end - inter.start);
				dst := Range.{start = sd, end = ed};
				array_add(*res, dst);
			}
		}

		quick_sort(cov, x => x.start);
		pos : u64 = in.start;
		for r : cov {
			gap : u64 = r.start - pos;
			if gap {
				dst := Range.{start = pos, end = gap-1};
				array_add(*res, dst);
			}
			pos = r.end;
		}

		if pos != in.end {
				dst := Range.{start = pos, end = in.end};
				array_add(*res, dst);
		}

		return res;
	}

	for m : all_mapings {
		na : [..]Range;
		for r : seed_ranges {
			array_add(*na, ..trace_range(r, m));
		}
		array_reset(*seed_ranges);
		seed_ranges = na;
	}

	min_loc := U64_MAX;
	for seed_ranges min_loc = min(min_loc, it.start);

	print("part2: %\n", min_loc);
}

main :: () {
	part1();
	part2();
}
