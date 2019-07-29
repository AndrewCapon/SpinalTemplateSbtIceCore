###############################################################################
#                                                                             #
# Copyright 2016 myStorm Copyright and related                                #
# rights are licensed under the Solderpad Hardware License, Version 0.51      #
# (the “License”); you may not use this file except in compliance with        #
# the License. You may obtain a copy of the License at                        #
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable       #
# law or agreed to in writing, software, hardware and materials               #
# distributed under this License is distributed on an “AS IS” BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or             #
# implied. See the License for the specific language governing                #
# permissions and limitations under the License.                              #
#                                                                             #
###############################################################################

TTY  = /dev/cu.usbmodem00000000001A1

chip.bin: hdl/chip.v hdl/chip.pcf MyTopLevel.v 
	yosys -q -p "synth_ice40 -blif chip.blif" hdl/chip.v MyTopLevel.v
	arachne-pnr -d 8k -P tq144:4k -p hdl/chip.pcf chip.blif -o chip.txt
	icepack chip.txt chip.bin

MyTopLevel.v: src/main/scala/mylib/*.scala
	sbt "runMain mylib.MyTopLevelVerilog"

.PHONY: upload
upload:
	stty -f $(TTY) raw
	cat chip.bin > $(TTY)

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.txt chip.ex chip.bin
