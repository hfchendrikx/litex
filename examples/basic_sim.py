from migen.fhdl.structure import *
from migen.sim.generic import Simulator, TopLevel
from migen.sim.icarus import Runner

class Counter:
	def __init__(self):
		self.ce = Signal()
		self.count = Signal(BV(37, True), reset=-5)
	
	def do_simulation(self, s):
		if s.cycle_counter % 2:
			s.wr(self.ce, 0)
		else:
			s.wr(self.ce, 1)
		print("Cycle: " + str(s.cycle_counter) + " Count: " + str(s.rd(self.count)))
	
	def get_fragment(self):
		sync = [If(self.ce, self.count.eq(self.count + 1))]
		sim = [self.do_simulation]
		return Fragment(sync=sync, sim=sim)

def main():
	dut = Counter()
	sim = Simulator(dut.get_fragment(), Runner(), TopLevel("my.vcd"))
	sim.run(20)

main()
