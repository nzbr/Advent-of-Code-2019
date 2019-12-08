module main

import os

fn main() {
	sdata := os.args[1].split(",")
	data := intcode.parse_strings(sdata)

	// Part One
	println(run_program(data, 12, 2))

	// Part Two
	mut running := true
	mut a := 0
	mut b := 0
	for running && a < data.len {
		for b = 0; b <= a; b++ {
			if run_program(data, a, b) == i64(19690720) {
				println('$a\t$b\t${(i64(100)*a)+b}')
				running = false
				break
			}
		}
		b = a
		for a = 0; a <= b; a++ {
			if run_program(data, a, b) == i64(19690720) {
				println('$a\t$b\t${(i64(100)*a)+b}')
				running = false
				break
			}
		}
		a = b
		a += 1
	}
}

fn run_program(data []i64, a i64, b i64) i64 {
	mut prog := data.clone()
	prog[1] = a
	prog[2] = b

	return interpret(prog)
}