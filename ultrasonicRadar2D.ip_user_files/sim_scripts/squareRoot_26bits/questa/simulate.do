onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib squareRoot_26bits_opt

do {wave.do}

view wave
view structure
view signals

do {squareRoot_26bits.udo}

run -all

quit -force
