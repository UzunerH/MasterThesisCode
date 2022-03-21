vlib work
vmap work work
vlog -work work ../top.sv ../tb.v ../*.v
vsim -voptargs="+acc" -t ns tb
do waveHAZARDUNIT.do
run -all
