module apb_protocol(pclk,prst,paddr,pwrite,pwdata,psel,penable,load,fetch,prdata,pready,pslverr);
  
  input logic pclk,prst,paddr,pwrite,psel,penable,load,fetch;
  input logic [31:0] pwdata;
  output reg[31:0] prdata;
  output logic pslverr;
  output reg [127:0] pready;
  reg [7:0]mem[127:0];
  integer i;
  initial begin
    for(i=0;i<128;i=i+1) begin
      mem[i]=8'h00;
    end
  end
 
  always @ (posedge pclk)
     begin
       if(load==1 && penable==1 && psel==1) begin //ACCESS state
         $writememh("image_i.hex",mem[i]);
         $display("data=%h",mem[i]);
         pready<=1;
         pslverr<=0;
         prdata[31:0]=pwdata[31:0];
       end
       else if(fetch==1 && penable==1 && psel==1) begin
         $readmemh("image_o.hex",mem[i]);
         $display("Data =%h", mem[i]);
         pready<=1;
         pslverr<=0;
         prdata[31:0]=pwdata[31:0];
       end
        
       else if(penable) begin //ACCESS state
         $readmemh("image_o.hex",mem[i]);
         $writememh("image_s.hex",mem[i]);
         if(pwrite==1 && load==1 && psel==1 ) begin
            if(paddr >=0 && paddr<=127) begin
               mem[paddr]=pwdata;
               pslverr<=0;
              prdata[31:0]=pwdata[31:0];
               pready<=1;
               pslverr<=0;
              end
            else begin
             $display("Out of memory");
            end
          end
          else begin  //ACCESS state
            $display("can't write in memory");
            $readmemh("image_s.hex",mem);
            pready<=1;
            pslverr<=0;
            prdata[31:0]=pwdata[31:0];
          end
        end
       else if(prst==1 && penable==1) begin//reset memory
        for (int i = 0; i < 128; i = i + 1) begin
          mem[i] <= 8'h00; 
          $display("memory is reseted");
        end
      end
       else if(penable==0 && pwrite==0) begin //SETUP state
         $display("Can't able to write to the memory");
         pready<=1;
         pslverr<=0;
         prdata<=0;
      end
      
       else if(pslverr) begin //IDLE state
        $display("error is occured");
      end
      else begin
        pready<=0;
        pslverr<=0;
      end
     end
  
endmodule