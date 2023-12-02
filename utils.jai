#import "Basic";
#import "File";
#import "String";

get_input :: () -> string {
	file_path := "input.txt";
	file, read := read_entire_file(file_path);
	if !read {
		print("Cannot read file: %\n", file_path);
		exit(1);
	}

	return file;
}

get_input_as_lines :: () -> []string {
	input := get_input();
    input.count -= 1; // remove last new line
	return split(input, "\n");
}
