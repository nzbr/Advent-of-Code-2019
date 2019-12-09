module intcode

// 1
fn (m mut Machine) add() {
	val := m.get_arg(0) + m.get_arg(1)
	if m.debug {
		println('ADD\t${m.get_arg(0)}\t${m.get_arg(1)}\t-> $${m.arg_addr(2)}\t[${val}]')
	}
	m.set_arg(2, val)
	m.rip += 4
}

// 2
fn (m mut Machine) mult() {
	val := m.get_arg(0) * m.get_arg(1)
	if m.debug {
		println('MULT\t${m.get_arg(0)}\t${m.get_arg(1)}\t-> $${m.arg_addr(2)}\t[${val}]')
	}
	m.set_arg(2, val)
	m.rip += 4
}

// 3
fn (m mut Machine) read() {
	mut value := i64(0)
	if m.realin {
		if m.debug {
			println('READ\t-> $${m.arg_addr(0)}')
		}
		panic("Real reading is not yet implemented!")
	} else {
		if m.stdin.len < 1 {
			panic("No data left in stdin!")
		}
		value = m.stdin[m.stdin.len-1]
		m.stdin.delete(m.stdin.len-1)
		if m.debug {
			println('READ\t-> $${m.arg_addr(0)}\t[${value}]')
		}
	}

	m.set_arg(0, value)

	m.rip += 2
}

// 4
fn (m mut Machine) prnt() {
	if m.realout {
		if m.debug {
			println('PRNT\t$${m.arg_addr(0)}')
		}
		println(m.get_arg(0))
	} else {
		if m.debug {
			println('PRNT\t$${m.arg_addr(0)}\t[${m.get_arg(0)}]')
		}
		m.stdout << m.get_arg(0)
	}

	m.rip += 2
}

// 5
fn (m mut Machine) jnz() {
	if m.debug {
		println('JNZ\t$${m.arg_addr(0)}\t${m.get_arg(1)}\t[${m.get_arg(0)}]')
	}
	if m.get_arg(0) != i64(0) {
		m.rip = m.get_arg(1)
	} else {
		m.rip += 3
	}
}

// 6
fn (m mut Machine) jz() {
	if m.debug {
		println('JZ\t$${m.arg_addr(0)}\t${m.get_arg(1)}\t[${m.get_arg(0)}]')
	}
	if m.get_arg(0) == i64(0) {
		m.rip = m.get_arg(1)
	} else {
		m.rip += 3
	}
}

// 7
fn (m mut Machine) lt() {
	if m.debug {
		println('JLT\t${m.get_arg(0)}\t${m.get_arg(1)}\t-> $${m.arg_addr(2)}')
	}
	if m.get_arg(0) < m.get_arg(1) {
		m.set_arg(2, 1)
	} else {
		m.set_arg(2, 0)
	}
	m.rip += 4
}

// 8
fn (m mut Machine) eq() {
	if m.debug {
		println('EQ\t${m.get_arg(0)}\t${m.get_arg(1)}\t-> $${m.arg_addr(2)}')
	}
	if m.get_arg(0) == m.get_arg(1) {
		m.set_arg(2, 1)
	} else {
		m.set_arg(2, 0)
	}
	m.rip += 4
}

// 99
fn (m mut Machine) halt() {
	if m.debug {
		println("HALT")
	}
	m.running = false
	m.rip = -1
}