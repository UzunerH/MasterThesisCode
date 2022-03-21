`timescale  1 ns / 1 ns
module tb;

parameter  per  =  10;

reg         clk;
reg         uart_rx;

wire [7:0]  leds;
wire        uart_tx;

top dut(
  .clk(clk),
  .leds(leds),
  .uart_rx(uart_rx),
  .uart_tx(uart_tx)
);

initial
  clk <= 1'b1;
always  #(per/2)
  clk <= ~clk;

initial
  begin
    uart_rx <= 0;
    #(250000*per);
    $stop;
  end

endmodule