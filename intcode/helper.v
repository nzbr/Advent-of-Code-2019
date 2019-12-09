module intcode

import strconv

pub fn parse_string(prog string) []i64 {
	a := prog.split(",")
	mut result := []i64
	for str in a {
		result << i64(strconv.atoi(str))
	}
	return result
}

pub fn to64(a []int) []i64 {
	mut result := []i64
	for i in a {
		result << i64(i)
	}
	return result
}

pub fn (m mut Machine) input(data []i64) {
	for d in data {
		m.stdin << d
	}
}

pub fn (m mut Machine) output() []i64 {
	result := m.stdout
	m.stdout = []
	return result
}