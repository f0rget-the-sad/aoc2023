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
    input.count -= 1; // remove last new line
	return split(input, "\n");
}
