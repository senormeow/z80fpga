import os
import sys

from myhdl import (Cosimulation, ResetSignal, Signal, Simulation,
                   StopSimulation, always, delay, instance, instances, intbv,
                   now)

cmd = "iverilog -gio-range-error -o z80.o ../rtl/*.v z80_tb.v"
err = os.system(cmd)
if(err):
    print(f"cmd error {err}")
    sys.exit(1)

dbus_out = Signal(intbv(0)[8:])
dbus_in = Signal(intbv(0)[8:])
address = Signal(intbv(0)[16:])
clk = Signal(bool(0))
vcc = Signal(bool(1))
# rd_n = Signal(bool())
# wr_n = Signal(bool())

reset = ResetSignal(0, active=0, isasync=True)

# MEMORY = [0x00 for i in range(4096)]
# MEMORY[0] = 0xC3
# MEMORY[1] = 0xa1
# MEMORY[2] = 0x00

def bench():

    cosim = Cosimulation("vvp -m myhdl z80.o",
                         reset=reset, 
                         clk=clk, 
                         dbus_in=dbus_in, 
                         dbus_out=dbus_out, 
                         address=address)

    @always(delay(1))
    def clkgen():
        clk.next = not clk

    @instance
    def test():
        reset.next = 1
        yield delay(10)
        reset.next = 0
        for i in range(20):
            yield address 
            #dbus_in.next = MEMORY[int(address)]
            print(f"Python {now()}  addr:{int(address):04x} dout:{int(dbus_out):02x} din:{int(dbus_in):02x}")
        
        raise StopSimulation

    return instances()

sim = Simulation(bench())
sim.run(0)