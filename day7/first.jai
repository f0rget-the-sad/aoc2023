#load "../utils.jai";

CardType :: enum u8 {
	HIGH;
	PAIR;
	TWO_PAIR;
	THREEK;
	FULL_HOUSE;
	FOURK;
	FIVEK;
}

Hand :: struct {
	cards : [5] u8;
	type : CardType;
	bid : u32;
}

compare_hands :: (a: Hand, b: Hand) -> s64 {
	if a.type != b.type return cast(s64) a.type - cast(s64) b.type;

	for 0..a.cards.count-1 {
		delta := cast(s64) a.cards[it] - cast(s64) b.cards[it];
		if delta return delta;
	}

	return 0;
}

part1 :: () {
	lines := get_input_as_lines("input.txt");

	parse_cards :: (s: string) -> [5]u8 {
		res : [5]u8;
		for i : 0..s.count-1 {
			c := s[i];
			if (is_digit(c)) {
				res[i] = c - #char "0";
			} else {
				b : u8 = 10;
				if      c == #char "J" b = 11;
				else if c == #char "Q" b = 12;
				else if c == #char "K" b = 13;
				else if c == #char "A" b = 14;
				res[i] = b;
			}
		}
		return res;
	}

	match_type :: (cards: [5]u8) -> CardType {
		//count : [15] u8;
		// XXX: how to reverse sort unsigned numbers with lambda
		r : [15] int;
		for cards {
			r[it] += 1;
		}

		quick_sort(r, x => -x);

		if r[0] == 5 return .FIVEK;
		else if r[0] == 4 return .FOURK;
		else if r[0] == 3 && r[1] == 2 return .FULL_HOUSE;
		else if r[0] == 3 return .THREEK;
		else if r[0] == 2 && r[1] == 2 return .TWO_PAIR;
		else if r[0] == 2 return .PAIR;
		return .HIGH;
	}

	hands : [..] Hand;
	for l : lines {
		parts := split(l, " ");
		cards := parse_cards(parts[0]);
		bid := aoc_parse_int(*parts[1], u32);
		h := Hand.{ cards = cards, type = match_type(cards), bid = bid };
		array_add(*hands, h);
	}

	quick_sort(hands, compare_hands);

	s : s64 = 0;
	for h : hands {
		s += (it_index + 1) * h.bid;
	}

	print("part 1: %\n", s);
}

part2 :: () {
	lines := get_input_as_lines("input.txt");

	parse_cards :: (s: string) -> [5]u8 {
		res : [5]u8;
		for i : 0..s.count-1 {
			c := s[i];
			if (is_digit(c)) {
				res[i] = c - #char "0";
			} else {
				b : u8 = 10;
				if      c == #char "J" b = 1;
				else if c == #char "Q" b = 12;
				else if c == #char "K" b = 13;
				else if c == #char "A" b = 14;
				res[i] = b;
			}
		}
		return res;
	}

	match_type :: (cards: [5]u8) -> CardType {
		r : [15] int;
		j := 0;
		for cards {
			if it == 1 j += 1;
			else r[it] += 1;
		}

		quick_sort(r, x => -x);

		r[0] += j;

		if r[0] == 5 return .FIVEK;
		else if r[0] == 4 return .FOURK;
		else if r[0] == 3 && r[1] == 2 return .FULL_HOUSE;
		else if r[0] == 3 return .THREEK;
		else if r[0] == 2 && r[1] == 2 return .TWO_PAIR;
		else if r[0] == 2 return .PAIR;
		return .HIGH;
	}

	hands : [..] Hand;
	for l : lines {
		parts := split(l, " ");
		cards := parse_cards(parts[0]);
		bid := aoc_parse_int(*parts[1], u32);
		h := Hand.{ cards = cards, type = match_type(cards), bid = bid };
		array_add(*hands, h);
	}

	quick_sort(hands, compare_hands);

	s : s64 = 0;
	for h : hands {
		s += (it_index + 1) * h.bid;
	}

	print("part 2: %\n", s);
}

main :: () {
	part1();
	part2();
}
