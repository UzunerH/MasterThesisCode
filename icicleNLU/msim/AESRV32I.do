vlib work
vmap work work
vlog -work work ../top.sv ../tb.v ../*.v
vsim -voptargs="+acc" -t ns tb
do waveAESRV32I.do
run -all
