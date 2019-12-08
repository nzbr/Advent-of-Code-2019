module main

import strconv

fn main() {
	mut counter := 0
	mut counter2 := 0

	for i := 168630; i <= 718098; i++ {
		str := i.str()
		if str.len != 6 {
			continue
		}

		mut lastnum := -1
		mut slastnum := -1
		mut tlastnum := -1
		mut matches := false
		mut matches2 := false
		for j := 0; j < str.len; j++ {
			char := str[j]
			num := strconv.atoi(char.str())

			// Part One
			if num == lastnum {
				matches = true
			}
			// Part Two
			if (lastnum == slastnum && num != lastnum && slastnum != tlastnum && slastnum != -1) || (j == str.len - 1 && num == lastnum && lastnum != slastnum) {
				matches2 = true
			}
			
			if num < lastnum {
				matches = false
				break
			}
			tlastnum = slastnum
			slastnum = lastnum
			lastnum = num
		}

		if matches {
			// Part One
			counter++
			print(str)

			// Part Two
			if matches2 {
				counter2++
				print(" +")
			}
			println("")
		}
	}
	println("\n\n1: "+counter.str()+"\n2: "+counter2.str())
}