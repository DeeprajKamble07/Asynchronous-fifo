// testbench for asynchronous fifo

module tb;
  reg wclk,rclk,rst,wen,ren;
  reg[7:0]wdata;
  wire[7:0]rdata;
  wire full,empty,overflow,underflow,valid;
  parameter width=8,depth=8;
  asynfifo #(8,8) dut(wclk,rclk,rst,wen,ren,wdata,rdata,full,empty,overflow,underflow,valid);
  initial begin
    wclk=0;
    forever #5 wclk=~wclk;
  end
  initial begin
    rclk=0;
    forever #10 rclk=~rclk;
  end
  initial begin
    rst=1;wen=0;ren=0;wdata=0;
    #20 rst=0;
    
    repeat(depth) begin
      @(posedge wclk);
      if(!full) begin
        wen=1;
        wdata=$random();
      end
    end
    @(posedge wclk);
    wen=0;
    
    repeat(depth) begin
      @(posedge rclk);
      if(!empty) begin
        ren=1;
      end
    end
    @(posedge rclk);
    ren=0;
    
    #200 $finish;
  end
  initial begin
    $monitor("[%0t] wclk=%0b rclk=%0b wen=%0b ren=%0b wdata=%0d rdata=%0d full=%0d empty=%0d overflow=%0d underflow=%0d valid =%0d",$time,wclk,rclk,wen,ren,wdata,rdata,full,empty,overflow,underflow,valid);
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
