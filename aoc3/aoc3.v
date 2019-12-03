module main

import os
import strconv

struct Vector2 {
	x int
	y int
}

struct Wirepart {
	pos Vector2
	len int
}

const (
	vec_origin = Vector2 {
		x: 0
		y: 0
	}

	vec_down = Vector2 {
		x: 0
		y: -1
	}

	vec_up = Vector2 {
		x: 0
		y: 1
	}

	vec_left = Vector2 {
		x: -1
		y: 0
	}

	vec_right = Vector2 {
		x: 1
		y: 0
	}
)

fn (v Vector2) add(a Vector2) Vector2 {
	return Vector2 {
		x: v.x + a.x
		y: v.y + a.y
	}
}

fn (v Vector2) eq(a Vector2) bool {
	return v.x == a.x && v.y == a.y
}

fn (v Vector2) mhtn_dist(a Vector2) int {
	return iabs(v.x - a.x) + iabs(v.y - a.y)
}

pub fn (v Vector2) str() string {
	return '($v.x | $v.y)'
}

// vlib's math.abs() returns floats, which I don't want
fn iabs(i int) int {
	if i < 0 {
		return -i
	} else {
		return i
	}
}

fn string_to_path(s string) []Vector2 {
	mut path := []Vector2
	for elem in s.split(",") {
		f := strconv.atoi(elem[1..])
		d := match elem[0] {
			`U`  {vec_up}
			`D`  {vec_down}
			`L`  {vec_left}
			`R`  {vec_right}
			else {vec_origin}
		}
		for i := 0; i < f; i++ {
			path << d
		}
	}
	return path
}

fn main() {
	text := os.read_file("data.txt") or { panic(err) }
	lines := text.split_into_lines()

	ps1 := lines[0]
	p1 := string_to_path(ps1)
	ps2 := lines[1]
	p2 := string_to_path(ps2)

	mut wire1 := []Wirepart
	mut wire2 := []Wirepart

	mut w1pos := vec_origin
	for i := 0; i < p1.len; i++ {
		w1pos = w1pos.add(p1[i])
		wire1 << Wirepart {
			pos: w1pos
			len: i+1
		}
	}

	mut w2pos := vec_origin
	for i := 0; i < p2.len; i++ {
		w2pos = w2pos.add(p2[i])
		wire2 << Wirepart {
			pos: w2pos
			len: i+1
		}
	}

	mut dists := []int
	mut steps := []int
	for i := 0; i < wire1.len; i++ {
		for j := 0; j < wire2.len; j++ {
			if wire1[i].pos.eq(wire2[j].pos) {
				println(wire1[i].pos)
				dists << wire1[i].pos.mhtn_dist(vec_origin)
				steps << wire1[i].len + wire2[j].len
			}
		}
	}
	
	// Part One
	dists.sort()
	println("\nClosest distance to central port")
	println(dists[0])

	// Part Two
	steps.sort()
	println("\nShortest combined wire length")
	println(steps[0])

}