module intcode

const (
	debug = false
)

struct Machine {
	mut:
		running bool
		mem     []i64
		rip     i64
}

pub fn interpret(program []i64) i64 {
	mut mach := Machine {
		running: true,
		mem: program,
		rip: 0
	}

	mach.run()

	return mach.mem[0]
}

fn (m mut Machine) run() {
	for m.running && m.rip < m.mem.len {
		if debug {
			print('${m.rip}/${m.mem.len}\t')
		}
		match m.mem[m.rip] {
			1    { m.add()  }
			2    { m.mult() }
			99   { m.halt() }
			else { panic('Unknow OpCode ${m.mem[m.rip]}') }
		}
	}
}

fn (m mut Machine) add() {
	if debug {
		println('\$${m.mem[m.rip+3]} = ${m.mem[m.mem[m.rip+1]]} + ${m.mem[m.mem[m.rip+2]]}')
	}
	m.mem[m.mem[m.rip+3]] = m.mem[m.mem[m.rip+1]] + m.mem[m.mem[m.rip+2]]
	m.rip += 4
}

fn (m mut Machine) mult() {
	if debug {
		println('\$${m.mem[m.rip+3]} = ${m.mem[m.mem[m.rip+1]]} * ${m.mem[m.mem[m.rip+2]]}')
	}
	m.mem[m.mem[m.rip+3]] = m.mem[m.mem[m.rip+1]] * m.mem[m.mem[m.rip+2]]
	m.rip += 4
}

fn (m mut Machine) halt() {
	if debug {
		println("HALT")
	}
	m.running = false
	m.rip = -1
}