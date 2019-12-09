module intcode

pub struct Machine {
	pub mut:
		debug   bool
		dumpmem bool
		realin  bool
		realout bool
		
		running bool
		mem     []i64
		rip     i64
		modes   []bool

		stdin   []i64
		stdout  []i64
}

pub fn new(program []i64) Machine {
	return Machine {
		running: true,
		mem: program.clone(),
		rip: 0
	}
}

pub fn (m mut Machine) reset(program []i64) {
	m.running = true
	m.mem = program.clone()
	m.rip = 0
}

/// MAIN LOOP

pub fn (m mut Machine) run() i64 {
	for m.running && m.rip < m.mem.len {
		instruction := m.mem[m.rip]
		inststr := instruction.str()
		m.modes = []
		if inststr.len > 2 {
			strmodes := inststr[0..inststr.len-2]
			for i := strmodes.len-1; i >= 0; i-- {
				if strmodes[i] == `1` {
					m.modes << true
				} else {
					m.modes << false
				}
			}
		}

		if m.debug {
			print(m.rip.str()+": ")
		}

		match instruction % 100 {
			1    { m.add()  } // ADD
			2    { m.mult() } // MULT
			3    { m.read() } // READ
			4    { m.prnt() } // PRNT
			5    { m.jnz()  } // JNZ
			6    { m.jz()   } // JZ
			7    { m.lt()   } // LT
			8    { m.eq()   } // EQ
			99   { m.halt() }
			else { panic('Unknow OpCode ${m.mem[m.rip]}') }
		}

		if m.dumpmem {
			print("|")
			for i, x in m.mem {
				if i64(i) == m.rip {
					print(" >"+x.str()+"< ")
				} else {
					print(" "+x.str()+" ")
				}
			}
			println("|")
		}
	}

	return m.mem[0]
}

/// HELPER FUNCTIONS

fn (m Machine) is_direct(n int) bool {
	return m.modes.len > n && m.modes[n]
}

fn (m Machine) arg_addr(n int) i64 {
	if m.is_direct(n) {
		return m.rip+n+1
	} else {
		return m.mem[m.rip+n+1]
	}
}

fn (m Machine) get_arg(n int) i64 {
	return m.mem[m.arg_addr(n)]
}

fn (m mut Machine) set_arg(n int, v i64) {
		m.mem[m.mem[m.rip+n+1]] = v
}

