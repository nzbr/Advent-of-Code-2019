module main

import os
import strconv
import math

fn main() {
	text := os.read_file("data.txt") or { panic(err) }
	lines := text.split_into_lines()
	mut weights := []int
	for line in lines {
		ldat := line.trim_space()
		if ldat != "" {
			weights << strconv.atoi(ldat)
		}
	}

	// Part One
	mut fuel_sum := 0
	for weight in weights {
		need := int(math.floor(f64(weight)/3)) - 2
		fuel_sum += need
	}
	println(fuel_sum)

	// Part Two
	fuel_sum = 0
	for weight in weights {
		mut w := weight
		for w > 0 {
			need := int(math.floor(f64(w)/3)) - 2
			if need > 0 {
				w = need
			} else {
				w = 0
			}
			fuel_sum += w
		}
	}
	println(fuel_sum)
}