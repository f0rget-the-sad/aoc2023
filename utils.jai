#import "Basic";
#import "File";
#import "Hash_Table";
#import "Math";
#import "Sort";
#import "String";

get_input :: (file_path := "input.txt") -> string {
	file, read := read_entire_file(file_path);
	if !read {
		print("Cannot read file: %\n", file_path);
		exit(1);
	}

	return file;
}

get_input_as_lines :: (file_path := "input.txt", new_line_in_end := false) -> []string {
	input := get_input(file_path);
	lines := split(input, "\n");
	if !new_line_in_end lines.count -= 1;
	return lines;
}

Basic :: #import "Basic";
using Basic;
// from 'modules/String'
// same as split but without empty elements
// XXX: suggest to have an option for this in std?
aoc_split :: (s: string, separator: $T, allocator := Basic.temp) -> [] string {  // separator must be a string or byte. Returns an array in temporary storage by default.
	#assert (T == u8) || (T == string);

	results: [..] string;
	results.allocator = allocator;

	remainder := s;
	while remainder {
		found, left, right := split_from_left(remainder, separator);
		if found {
			if (left.count)
				array_add(*results, left);
		} else {
			array_add(*results, remainder);
			break;
		}

		remainder = right;
	}

	return results;
}

aoc_parse_int :: (line: *string, $T : Type = int) -> T {
	value, ok := parse_int(line, T);
	assert(ok);
	return value;
}

// from 'how_to/110_polymorphic_arguments.jai'
map :: (array: [] $T, f: (T) -> $S) -> [..] S {
	results: [..] S;

	for array array_add(*results, f(it));

	return results;
}

/* XXX: overloaded function does not resolve for map-like
str2int :: (line: string, asdf: bool) -> int {
	print("This is bool version\n");
	return aoc_parse_int(*line, int);
}
*/

str2int :: (line: string) -> int {
	return aoc_parse_int(*line, int);
}
