// Design for asynchronous fifo

module asynfifo#(parameter width=8,depth=8,addr=$clog2(depth))(input wclk,rclk,rst,wen,ren,input [width-1:0]wdata,output reg[width-1:0]rdata,output full,empty,output reg overflow,underflow,valid);
  reg[width-1:0]mem[0:depth-1];
  reg[addr:0] wptr,rptr,wptr_g,rptr_g,wptr_g_s1,wptr_g_s2,rptr_g_s1,rptr_g_s2;
  
  always@(posedge wclk)
    begin
      if(rst)
        wptr<=0;
      else if(wen && !full) begin
        mem[wptr]<=wdata;
        wptr<=wptr+1;
      end
    end
  
  always@(posedge rclk)
    begin
      if(rst)
        rptr<=0;
      else if(ren && !empty) begin
        rdata<=mem[rptr];
        rptr<=rptr+1;
      end
    end
  
  assign wptr_g=wptr^(wptr>>1);
  assign rptr_g=rptr^(rptr>>1);
  
  always@(posedge rclk)
    begin
      if(rst) begin
        wptr_g_s1<=0;
        wptr_g_s2<=0;
      end
      else begin
        wptr_g_s1<=wptr_g;
        wptr_g_s2<=wptr_g_s1;
      end
    end
  
  always@(posedge wclk)
    begin
      if(rst) begin
        rptr_g_s1<=0;
        rptr_g_s2<=0;
      end
      else begin
        rptr_g_s1<=rptr_g;
        rptr_g_s2<=rptr_g_s1;
      end
    end
  
  assign empty=(wptr_g_s2==rptr_g);
  assign full=(rptr_g_s2[addr]!=wptr_g[addr])&&(rptr_g_s2[addr-1]!=wptr_g[addr-1])&&(rptr_g_s2[addr-2:0]==wptr_g[addr-2:0]);
  
  always@(posedge wclk)
    begin
      overflow=(wen && full);
    end
  always@(posedge rclk)
    begin
      underflow=(ren && empty);
      valid=(ren && !empty);
    end
endmodule
