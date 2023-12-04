#import "Basic";
#import "File";
#import "Hash_Table";
#import "String";

get_input :: (file_path := "input.txt") -> string {
	file, read := read_entire_file(file_path);
	if !read {
		print("Cannot read file: %\n", file_path);
		exit(1);
	}

	return file;
}

get_input_as_lines :: (file_path := "input.txt") -> []string {
	input := get_input(file_path);
	return aoc_split(input, "\n");
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
